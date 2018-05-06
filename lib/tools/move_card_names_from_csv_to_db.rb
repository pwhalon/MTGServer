#!/usr/bin/env ruby
require 'csv'
Rails.application.eager_load!

NAME = 'name'.freeze

card_files = Dir.glob('/home/patrick/Documents/other/totalCardsCsv/*preprocessed.csv')
card_files.each do |file_name|
  card_file = File.read(file_name)
  card_list = CSV.parse(card_file, headers: true)

  p "-- Starting load all cards process --"

  card_list.each do |card|
    # Add the card parsed to the database.
    begin
      new_card = MagicCard.create(name: card[NAME])
      if new_card.valid?
        p "Card entry inserted for #{new_card.name}"
        new_card.save
      else
        p "DUPLICATE CARD: #{card[NAME]}"
      end
    end
  end

  p "-- End of Magic Card list --"
end
