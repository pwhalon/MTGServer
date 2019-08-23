require 'json'

desc 'Ingest all of the cards from the Scryfall bulk card data file'
task :ingest_bulk_card_info, [:new_set] => :environment do |task, args|
  NAME = 'name'.freeze
  CMC = 'cmc'.freeze
  MANA_COST = 'mana_cost'.freeze
  CARD_TYPE = 'type_line'.freeze
  RARITY = 'rarity'.freeze
  IMAGE_URL = 'image_uris'.freeze
  IMAGE_SIZE = 'small'.freeze
  MULTIVERSE_ID = 'multiverse_ids'.freeze
  PRICE = 'usd'.freeze
  LANG = 'lang'.freeze
  ENGLISH = 'en'.freeze
  LAYOUT = 'layout'.freeze
  TOKEN = 'token'.freeze
  SET = 'set'.freeze
  BASIC_LANDS = ['Swamp', 'Mountain', 'Island', 'Forest', 'Plains'].freeze

  Rails.application.eager_load!

  json_card_list = File.read('/home/patrick/Documents/other/totalCards/scryfall-default-cards.json')

  p "-- Starting load all cards process --"

  card_list = JSON.parse(json_card_list)

  card_list.each do |card|
    # Add the card parsed to the database.
    begin
      unless args.new_set && card[SET] == args.new_set
        puts "Skipped due to non-new set #{args.new_set} does not have #{card[NAME]}"
        next
      end

      unless card[MULTIVERSE_ID].present?
        puts "Skipped due to missing Multiverse ID: #{card[NAME]}"
        next
      end

      unless card[IMAGE_URL].try(:[], IMAGE_SIZE).present?
        puts "Skipped due to missing image: #{card[NAME]}"
        next
      end

      if BASIC_LANDS.include?(card[NAME])
        puts "Skipped due to basic land: #{card[NAME]}"
        next
      end

      unless card[LANG] == ENGLISH
        puts "Skipped due to non-english card: #{card[NAME]}"
        next
      end

      if card[LAYOUT] == TOKEN
        puts "Skipped due to token layout: #{card[NAME]}"
        next
      end

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
          name: card[NAME],
          cmc: card[CMC],
          mana_cost: card[MANA_COST],
          rarity: card[RARITY],
          card_type: card[CARD_TYPE],
          multiverse_id: card[MULTIVERSE_ID].first,
          image_url: card[IMAGE_URL][IMAGE_SIZE],
          price: card[PRICE]
        )
        if new_card.valid?
          p "New Card entry inserted for #{new_card.name}"
          new_card.save
        else
          p 'Error: '
          p new_card.errors
        end
      end
    end
  end

  p "-- End of Magic Card list --"
end
