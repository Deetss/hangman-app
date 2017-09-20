require 'sinatra' 
require 'sinatra/reloader' if development?
require './lib/game.rb'

get '/play_game' do
    game = Game.new
    blanks = ""
    guess = params[guess]
    game.hidden_word.each_char do |dash|
       blanks << dash + " "
    end
    erb :play_game, :locals => {:blanks => blanks}
end

get '/' do
    erb :index
end