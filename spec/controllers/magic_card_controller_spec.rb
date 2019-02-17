require 'rails_helper'

RSpec.describe MagicCardController, type: :controller do
  describe '#names' do
    context 'when there are names to retrieve' do
      let!(:setup_magic_cards) do
        MagicCard.create(name: 'Name1')
      end

      it 'returns a list of those names' do
        get :names

        expect(response.body).to eq(MagicCard.all.pluck(:name).to_json)
      end
    end

    context 'when there are no names to retrieve' do
      it 'returns an empty list' do
        get :names

        expect(response.body).to eq([].to_json)
      end
    end
  end
end
