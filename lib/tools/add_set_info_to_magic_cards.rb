#!/usr/bin/env ruby

require 'json'

Rails.application.eager_load!

MagicCard.all.each do |mtg_entry|
  if mtg_entry.set_price_hash.blank?
    list = ScryfallClient.instance.get_all_prints(mtg_entry.name)

    # Gotta remove the list cards.
    # Cards from pList are re-prints with the same og set.
    list.delete_if { |card| card['set'] == 'plist' }

    p "Updating #{mtg_entry.name}"

    set_info = {}

    list.each do |card|
      p "\t With set #{card['set']} -> $#{card['prices']['usd']}"

      set_info[card['set']] = card['prices']['usd']
    end

     mtg_entry.set_price_hash = set_info

     mtg_entry.save!
  else
    p "skipped #{mtg_entry.name} cause we have a set already"
  end

  # Cant be spamming ya know.
  sleep(0.5)
end
