require 'json'

desc 'Ingest all of the cards from the Scryfall bulk card data file'
task :ingest_bulk_card_info => :environment do
  NAME = 'name'.freeze
  CMC = 'cmc'.freeze
  MANA_COST = 'mana_cost'.freeze
  CARD_TYPE = 'type_line'.freeze
  RARITY = 'rarity'.freeze
  IMAGE_URL = 'image_uris'.freeze
  IMAGE_SIZE = 'small'.freeze
  MULTIVERSE_ID = 'multiverse_ids'.freeze
  PRICE = 'usd'.freeze

  Rails.application.eager_load!

  json_card_list = File.read('/home/patrick/Documents/other/totalCards/scryfall-default-cards.json')

  p "-- Starting load all cards process --"

  card_list = JSON.parse(json_card_list)

  card_list.each do |card|
    # Add the card parsed to the database.
    begin
      existing_card = MagicCard.find_by(name: card[NAME])

      if existing_card.present?
        existing_card.update(
          cmc: card[CMC],
          mana_cost: card[MANA_COST],
          rarity: card[RARITY],
          card_type: card[CARD_TYPE],
          multiverse_id: card[MULTIVERSE_ID].first,
          image_url: card[IMAGE_URL].try(:[], IMAGE_SIZE),
          price: card[PRICE]
        )
        p "Card entry updated for #{card[NAME]}"
      else
        new_card = MagicCard.create(
          cmc: card[CMC],
          mana_cost: card[MANA_COST],
          rarity: card[RARITY],
          card_type: card[CARD_TYPE],
          multiverse_id: card[MULTIVERSE_ID].first,
          image_url: card[IMAGE_URL][IMAGE_SIZE],
          price: card[PRICE]
        )
        if new_card.valid?
          p "Card entry inserted for #{new_card.name}"
          new_card.save
        else
          p "WARNING: #{new_card.errors}"
        end
      end
    end
  end

  p "-- End of Magic Card list --"
end
