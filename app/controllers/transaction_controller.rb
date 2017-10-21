class TransactionController < ApplicationController
  skip_before_action :verify_authenticity_token

  NEW_CARD_FIELDS = ['name', 'quantity', 'box_number']

  def index
  end

  def add_cards
    filter_params = params.require('cards')

    unless filter_params.any?
      flash.now[:error] = 'Please use the correct format'
      return render :index, status: :bad_request
    end

    flash[:error] = []
    flash[:notice] = []
    valid_cards = []

    filter_params.each.with_index do |card, index|
      filter_card = card.permit(:name, :quantity, :box_number)
      new_card = MyCard.with_name(card[:name]).with_box_number(card[:box_number])

      if new_card.empty?
        new_card = MyCard.new(name: card[:name],
          quantity: card[:quantity],
          box: card[:box_number]
        )

        if new_card.valid?
          flash.now[:notice] << "#{index + 1}. Successfully added #{new_card.name}"

          valid_cards << new_card
        else
          flash.now[:error] << "#{index + 1}. " + new_card.errors.full_messages.to_sentence
        end
      else
        flash.now[:error] <<
          "#{index + 1}. You already have #{new_card.first.name} in box #{new_card.first.box} on the transaction tab"
      end
    end

    unless flash[:error].any?
      valid_cards.each { |card| card.save }
    end

    render :index
  end
end
