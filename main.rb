require 'rubygems'
require 'sinatra'
require 'sinatra/contrib/all' #Windows OS gem to allow shotgun functionality
load "public/blackjack_oo_classes.rb"

set :sessions, true

get '/' do
  if session[:username] == nil
  	erb :new_user
  else
  	redirect '/game'
  end
end

get '/game' do
  session[:deck] = Cards.new
  erb :game
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

