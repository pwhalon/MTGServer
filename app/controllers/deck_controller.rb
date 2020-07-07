class DeckController < ApplicationController
  ACTIVE = 'active'.freeze

  def index
    @active_deck = (params[ACTIVE] || -1)

    @decks = Deck.all.to_a
  end

  def new
    @deck = Deck.new
  end

  def create
    deck = Deck.new(filter_deck_params).save!

    redirect_to action: :index
  rescue ActionController::ParameterMissing, ActiveRecord::RecordInvalid
    return redirect_to action: :new
  end

  def delete
    deck_to_delete = Deck.find_by(id: params['id'])

    if deck_to_delete.blank?
      flash[:error] = 'Invalid deck id. Unable to delete non-existent deck.'
      return
    else
      flash[:success] = 'Success! Deleted deck and associated deck entries.'
      deck_to_delete.destroy
    end
  end

  def search_cards
    matching_cards = MyCard.with_name(params['name'])

    render partial: 'setup_card_results', locals: { deck_id: params['deckId'], matching_cards: matching_cards }, status: :ok
  end

  def add_cards
    params.permit('cards')

    if params['cards'].blank? || !params['cards'].is_a?(Array)
      return render json: { error: 'Invalid Request' }, status: :bad_request
    end

    errors = []
    status = :ok

    params.fetch('cards').each do |card|
      my_card = MyCard.with_name(card['name']).with_box_number(card['box']).first

      if my_card.blank?
        errors << "Error: You do not have #{card['name']} card in box number #{card['box']}"
        status = :bad_request
        next
      end

      quantity = begin
        Integer(card['quantity'])
      rescue ArgumentError => e
        errors << "Error: #{card['quantity']} is not a valid quantity to add"
        status = :bad_request
        next
      end

      next if quantity.zero?

      available_quantity = my_card.quantity - MyCard.cards_in_use(my_card.id).pluck(:quantity).inject(0, :+)

      if quantity > available_quantity
        errors << "Error: #{card['quantity']} is greater than that cards available quantity (available: #{available_quantity})"
        status = :bad_request
        next
      end

      deck_card = DeckEntry.find_or_create_by(deck_id: card['deckId'], my_card_id: my_card.id)

      original_quantity = deck_card.quantity || 0

      deck_card.update(quantity: quantity + original_quantity)

      if deck_card.quantity.zero?
        deck_card.destroy!
      elsif deck_card.valid?
        deck_card.save!
      else
        errors << deck_card.errors.full_messages.to_sentence
        status = :bad_request
      end
    end

    render json: { errors: errors }, status: status
  end

  private

  def filter_deck_params
    params.require('deck').permit('name', 'format')
  end
end
