#!/usr/bin/env ruby

Rails.application.eager_load!

total_count = 0

MyCard.all.each do |card_entry|
  if card_entry.set_code.blank?
    list = ScryfallClient.instance.get_all_prints(card_entry.name)

    # Gotta remove the list cards.
    # Cards from pList are re-prints with the same og set.
    list.delete_if { |card| card['set'] == 'plist' }

    if list.count == 1
      p "Updated set info for #{card_entry.name} to set #{list.first['set_name']} (#{list.first['set']})"
      card_entry.set_code = list.first['set']

      card_entry.save!

      total_count += 1
    else
      p "Skipped: #{card_entry.name} cause it was printed #{list.count} times"
    end
  else
    p "skipped #{card_entry.name} cause we have a set already"
  end

  # Cant be spamming ya know.
  sleep(0.5)
end

p "Total count: #{total_count}"