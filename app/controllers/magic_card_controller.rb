class MagicCardController < ApplicationController
  def names
    render json: MagicCard.all.pluck(:name).to_json
  end
end
