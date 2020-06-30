desc 'Update Price Info for YOUR Cards'
task :update_price_data => :environment do
  require 'services/scryfall_client'

  unique_names = MyCard.all.pluck(:name).uniq

  scryfall_client = ScryfallClient.instance

  PRICES = 'prices'.freeze
  DOLLARS = 'usd'.freeze

  unique_names.each do |card_name|
    puts "Looking up price information for #{card_name}"

    magic_card = MagicCard.find_by(name: card_name)

    if magic_card.multiverse_id.blank?
      puts "Cannot look up information for #{card_name}, the multiverse_id is not available"
      next
    end

    card_data = scryfall_client.get_card_data(magic_card.multiverse_id)

    puts "Retrieved card price data for #{card_name}: \n PRICE DATA: #{card_data[PRICES]}"

    magic_card.price = card_data[PRICES][DOLLARS]

    magic_card.save!

    puts "Saved price information ($#{card_data[PRICES][DOLLARS]}) for #{card_name}"

    # Make sure not to make more than 10 calls per second
    sleep(1)
  end
end