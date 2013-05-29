require 'rubygems'
require 'sinatra'
require 'sinatra/contrib/all' #Windows OS gem to allow shotgun functionality
set :sessions, true

helpers do

  def card_img_selector (card)
    face = case card[0]
      when 2..10 then card[0]
      when 'J' then 'jack'
      when 'Q' then 'queen'
      when 'K' then 'king'
      when 'A' then 'zce'
    end
    suit = case card[1]
      when 'H' then 'hearts'
      when 'D' then 'diamonds'
      when 'S' then 'spades'
      when 'C' then 'clubs'
    end
    return "/img/cards/#{suit}_#{face}.jpg"
  end
  
  def calculate_total (hand)
    total = 0
    aces = 0
    for i in 0...hand.count
      if hand[i][0] == 'J' || hand[i][0] == 'Q' || hand[i][0] == 'K'
        total += 10
      elsif hand[i][0].to_i != 0
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
  
  def dealer_action?
    if calculate_total(session[:dealer_cards]) > 21
      @dealer_bust = true
    elsif 
  end

end

before do
  @show_hit_and_stay_buttons = true
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

post '/game/player/hit' do
  session[:player_cards] << session[:deck].pop
  if calculate_total(session[:player_cards]) > 21
    @error = "You have busted, the dealer wins!"
    @show_hit_and_stay_buttons = false
  end
  erb :game
end

post '/game/player/stay' do
  @success = "You have chosen to stay"
  @show_hit_and_stay_buttons = false
  erb :game
end