#!/usr/bin/env ruby
require 'csv'
Rails.application.eager_load!

NAME = 'name'.freeze
QUANTITY = 'quantity'.freeze
BOX_NUMBER_REGEX = /\d+/.freeze

card_files = Dir.glob('/home/patrick/Documents/other/myCsvCards/*).csv')
card_files.each do |file_name|
  card_file = File.read(file_name)
  card_list = CSV.parse(card_file, headers: true)

  box_number = Integer(file_name[BOX_NUMBER_REGEX])
  p "-- Box number #{box_number} starting --"

  card_list.each do |card|
    # Add the card parsed to the database.
    begin
      MyCard.create(name: card[NAME], quantity: Integer(card[QUANTITY]), box: box_number)
      p "Card entry inserted #{card[NAME]} with quantity #{card[QUANTITY]}"
    rescue ArgumentError
      p "\nERROR CARD: #{card}\n"
      MyCard.create(name: card[NAME], quantity: 0, box: box_number)
    end
  end

  p "-- Box number #{box_number} ending --"
end
