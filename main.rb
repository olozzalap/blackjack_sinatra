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
      when 'A' then 'ace'
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
      @show_cards = true
      session[:dealer_stay] = true
      session[:player_stay] = true
      @success = "The dealer has busted and you win!"
      halt erb :game
    elsif calculate_total(session[:dealer_cards]) == 21
      @show_cards = true
      session[:dealer_stay] = true
      session[:player_stay] = true
      @error = "Sorry the dealer has Blackjack and you lose!"
      halt erb :game
    elsif calculate_total(session[:dealer_cards]) > 16 && session[:player_stay] = true
      session[:dealer_stay] = true
      halt redirect '/game/compare'
    elsif calculate_total(session[:dealer_cards]) > 16
      session[:dealer_stay] = true
      halt erb :game
    else
      @dealer_hit = true
      erb :game
    end
  end

  def player_bust_or_win?
    if calculate_total(session[:player_cards]) == 21
      @success = "Congratulations, you have 21 and you win!"
      session[:player_stay] = true
      session[:dealer_stay] = true
      @show_cards = true
      halt erb :game
    elsif calculate_total(session[:player_cards]) > 21
      @error = "You have busted, the dealer wins!"
      session[:player_stay] = true
      session[:dealer_stay] = true
      @show_cards = true
      halt erb :game
    end
  end

  def dealer_bust_or_win?
    if calculate_total(session[:dealer_cards]) == 21
      @error = "The dealer has blackjack, you lose..."
      session[:player_stay] = true
      session[:dealer_stay] = true
      @show_cards = true
      halt erb :game
    elsif calculate_total(session[:player_cards]) > 21
      @success = "You dealer has busted and you win!"
      session[:player_stay] = true
      session[:dealer_stay] = true
      @show_cards = true
      halt erb :game
    end
  end

end

before do

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
  if params[:username].empty?
    @error = "A username is required, hotshot!"
    halt erb :new_user
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
  session[:dealer_stay] = false
  session[:player_stay] = false
  player_bust_or_win?
  erb :game
end

post '/game/player/hit' do
  session[:player_cards] << session[:deck].pop
  player_bust_or_win?
  @player_hit = true
  erb :game
end

post '/game/player/stay' do
  @success = "You have chosen to stay"
  session[:player_stay] = true
  erb :game
end

get '/game/dealer' do
  dealer_action?
end

get '/game/dealer/hit' do
  session[:dealer_cards] << session[:deck].pop
  dealer_bust_or_win?
  erb :game
end

get '/game/compare' do
  @show_cards = true
  @show_hit_and_stay_buttons = false
  if calculate_total(session[:player_cards]) > calculate_total(session[:dealer_cards])
    @success = "The dealer has #{calculate_total(session[:dealer_cards])} and you have #{calculate_total(session[:player_cards])}. You win!!!"
  else
    @error = "The dealer has #{calculate_total(session[:dealer_cards])} and you have #{calculate_total(session[:player_cards])}. You lose..."
  end
  erb :game
end