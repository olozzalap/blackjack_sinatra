require blackjack_oo_classes.rb

puts "How many decks do you want to play Blackjack with?"
print "> "
num_of_decks = gets.chomp.to_i

game_cards = Cards.new(num_of_decks)
player = Player.new
dealer = Dealer.new

until player.