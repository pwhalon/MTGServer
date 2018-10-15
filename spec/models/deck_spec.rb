require 'rails_helper'

RSpec.describe Deck do
  describe 'valid?' do
    context 'when both name and format are provided' do
      it 'returns true' do
        expect(Deck.new(name: 'name', format: 'EDH').valid?).to eq(true)
      end
    end

    context 'when name is not provided' do
      it 'returns false' do
        expect(Deck.new(format: 'EDH').valid?).to eq(false)
      end
    end

    context 'when the format is not one of the valid formats' do
      it 'returns false' do
        expect(Deck.new(name: 'name', format: 'invalid').valid?).to eq(false)
      end
    end
  end
end