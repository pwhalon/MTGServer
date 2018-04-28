class TransactionController < ApplicationController
  skip_before_action :verify_authenticity_token

  NEW_CARD_FIELDS = ['name', 'quantity', 'box_number', 'transaction_entry']

  def index
  end

  def add_cards
    parsed_params = JSON.parse(params['list'])

    transaction_failures = []
    status = :ok

    parsed_params.each do |transaction|
      filter_transaction = transaction.slice(*NEW_CARD_FIELDS)

      transaction_card = MyCard
        .with_name(filter_transaction['name'])
        .with_box_number(filter_transaction['box_number'])

      if transaction_card.empty?
        transaction_card = MyCard.create_card(filter_transaction)
      else
        transaction_card = transaction_card.make_transaction(filter_transaction)
      end

      if !transaction_card.valid?
        Rails.logger.warn("Transaction #{filter_transaction} failed because #{transaction_card.errors.full_messages.to_sentence}")
        filter_transaction[:error] = transaction_card.errors.full_messages.to_sentence
        status = :bad_request
      end

      transaction_failures << filter_transaction
    end

    render json: transaction_failures.to_json, status: status
  rescue JSON::ParserError
    Rails.logger.warn("Error failed to parse json params: #{params}")
    return render :bad_request
  end
end
