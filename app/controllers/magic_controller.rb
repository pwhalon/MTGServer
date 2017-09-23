class MagicController < ApplicationController
  def index
  end

  def cards
  end

  def search
    params.permit(:magic_card_search)
    @matching_cards = MyCard.with_name(params[:magic_card_search])
    render :index
  end
end
