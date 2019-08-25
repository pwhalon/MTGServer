desc 'Add the correct magic card id to the my card table'
task :update_my_cards_table => :environment do
  MyCard.all.each do |card|
    card.magic_card_id = MagicCard.find_by(name: card.name).id
    if card.valid?
      card.save!
    else
      p "Error: #{card.errors.full_messages} for #{card.name}"
    end
  end
end