class DeckController < ApplicationController
  def index
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

  private

  def filter_deck_params
    params.require('deck').permit('name', 'format')
  end
end
