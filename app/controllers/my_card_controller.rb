class MyCardController < ApplicationController
  GATHERER_MULTIVERSE_URL = 'http://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid='.freeze

  def index
  end

  def search
    params.permit(:magic_card_search)
    @matching_cards = MyCard.with_name(params[:magic_card_search])
    render :index
  end

  def traders
    @traders = MyCard.cards_for_trade
  end

  def names
    redner json: MyCard.all.pluck(:name)
  end
end
