class Cards
  attr_accessor :cards
  
  @card_faces = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K', 'A']
  @card_suits = ['H', 'D', 'C', 'S']
  
  def initialize (decks=1)
	@cards = []
	decks.to_i.times do |deck|
	  @card_suits.each do |suit|
	    @card_faces.each do |face|
	      @cards << [face, suit]
		end
	  end
	end
	@cards.shuffle!
  end

  def hit
    hand << @cards.pop
  end

  def start
    hit
	hit
  end
  
  def cards_showing
    for i in 1..hand.count
	  print "A #{hand[i].card_display} \n"
	end
  end
  
  def card_display(card)
    face = case card[0]
	            when 2..10 then card[0]
				when 'J' then 'Jack'
				when 'Q' then 'Queen'
				when 'K' then 'King'
				when 'A' then 'Ace'
		   end
	suit = case card[1]
	         when 'H' then 'Hearts'
			 when 'D' then 'Diamonds'
			 when 'S' then 'Spades'
			 when 'C' then 'Clubs'
		   end
    return "#{face} of #{suit}"
  end
  
  def play_again?
  end
  
  def value_calc
    for i in 0..hand.count
	  if hand[i][0] == 'K' || hand[i][0] == 'J' || hand[i][0] == 'Q'
	    value += 10
	  elsif hand[i][0] == 'A'
	    aces += 1
		value += 1
	  else
        value += hand[i][0]
	  end
	end
    if value > 21
      return bust
	end
  end
  
end

class Dealer < Cards
	attr_accessor :value, :hand, :aces

  def initialize
		@hand = []
		@name = "The Dealer"
		@value = 0
		@aces = 0
		@stay = false
  end
  
  def bust
    puts "The dealer has busted, you win!"
	play_again?
  end
  
  def dealer_stay
    puts "The dealer has chosen to stay"
	@stay = true
  end
  
  def ideal_value
    if value <= 11 && aces > 0
	  return value + 10
	else
	  return value
	end
  end
  
  def hit?
    if value >= 17 || ideal_value >= 19
	  dealer_stay
	else
	  hit
	end
  end
end
  
class Player < Cards
	attr_accessor :hand, :name, :aces, :value

	def initialize
		@hand = []
		@value = 0
		@aces = 0
		@name = ''
		@stay = false
	end
	
	def check_hand
	  print " \n #{name} you have: "
	  print "A #{hand[0].card_display} (which is not showing) \n"
	  for i in 1..hand.count
	    print "A #{hand[i].card_display} \n"
	  end
	end
  
  def bust
    puts "You have busted, the Dealer wins!"
	play_again?
  end
  
  def player_stay
    puts "You have chosen to stay!"
	@stay = true
	return
  end
  
end
