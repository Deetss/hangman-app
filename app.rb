require 'sinatra' 
require 'sinatra/reloader' if development?
require './lib/game.rb'

get '/' do
    game = Game.new
    word = word = game.secret_word
    erb :index, :locals => {:blanks => blanks}
end