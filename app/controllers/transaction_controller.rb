class TransactionController < ApplicationController
  skip_before_action :verify_authenticity_token

  NEW_CARD_FIELDS = [:name, :quantity, :box_number, :transaction_entry]

  def index
  end

  def transaction
    parsed_params = JSON.parse(params['list'], symbolize_names: true)

    transaction_failures = []
    status = :ok

    parsed_params.each do |transaction|
      filter_transaction = transaction.slice(*NEW_CARD_FIELDS)

      transaction_card = MyCard.find_by(name: filter_transaction[:name], box: filter_transaction[:box_number])

      if transaction_card.blank?
        transaction_card = MyCard.new(
          name: transaction[:name],
          quantity: transaction[:quantity],
          box: transaction[:box_number]
        )
      else
        transaction_card.update(quantity: transaction[:quantity].to_i + transaction_card.quantity)
      end

      if !transaction_card.valid?
        Rails.logger.warn("Transaction #{filter_transaction} failed because #{transaction_card.errors.full_messages.to_sentence}")
        filter_transaction[:error] = transaction_card.errors.full_messages.to_sentence
        status = :bad_request
      else
        transaction_card.save!
      end

      transaction_failures << filter_transaction
    end

    render json: transaction_failures.to_json, status: status
  rescue JSON::ParserError
    Rails.logger.warn("Error failed to parse json params: #{params}")
    return render :bad_request
  end
end
