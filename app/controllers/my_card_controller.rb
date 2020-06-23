class MyCardController < ApplicationController
  GATHERER_MULTIVERSE_URL = 'http://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid='.freeze

  def index
  end

  def search
    params.permit(:magic_card_search)
    @matching_cards = MyCard.with_name(params[:magic_card_search])

    if @matching_cards.present?
      @deck_entries = @matching_cards.map { |card| MyCard.cards_in_use(card.id) }
    end

    render :index
  end

  def traders
    @traders = MyCard.cards_for_trade
  end

  def names
    redner json: MyCard.all.pluck(:name)
  end
end
