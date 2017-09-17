class MagicController < ApplicationController
  def index
  end

  def cards
  end

  def search
    params.permit(:magic_card_search)
    cards = MyCard.with_name(params[:magic_card_search])
    render :index, plain: cards.to_json
  end
end
