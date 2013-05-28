require 'rubygems'
require 'sinatra'
require 'sinatra/contrib/all' #Windows OS gem to allow shotgun functionality
set :sessions, true

helpers do

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
  
  def calculate_total (hand)
    total = 0
    aces = 0
    for i in 0..hand.count
      if hand[i][0] == 'J' || hand[i][0] == 'Q' || hand[i][0] == 'K'
        total += 10
      elsif hand[i][0] == 2..10
        total += hand[i][0]
      elsif hand[i][0] == 'A'
        total += 11
        aces += 1
      end
    end
    aces.times do
      break if total <= 21
      total -= 10
    end
    return total
  end
  
end


get '/' do
  if session[:username] == nil
  	erb :new_user
  else
  	redirect '/game'
  end
end

post '/new_user' do
  session[:username] = params[:username]
  if session[:username] == nil
  	erb :new_user
  else
  	redirect '/game'
  end
end

get '/new_user' do
  erb :new_user
end

get '/game' do
  card_faces = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K', 'A']
  card_suits = ['H', 'D', 'C', 'S']
  session[:deck] = card_faces.product(card_suits).shuffle!
  session[:dealer_cards] = []
  session[:player_cards] = []
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop
  erb :game
end

post '/hit_stay' do
  if params[:hit]
    session[:player_cards] << session[:deck].pop
  end
end