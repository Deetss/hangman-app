require 'sinatra' 
require 'sinatra/reloader' if development?
require './lib/game.rb'

enable :sessions

get '/make_guess' do
    session[:guess] = params[:guess]
    $game.show_letter
    $game.end_turn
    if $game.player_won?
        redirect '/win'
    end
    redirect '/play_game'
end

get '/new_game' do
    $game = Game.new
    session.delete(:guess)
    redirect '/play_game'
end

get '/play_game' do
    blanks = ""
    guess = session[:guess]

    feedback = $game.check_guess(guess) unless guess.nil?
    $game.hidden_word.each_char do |dash|
       blanks << dash + " "
    end
    p $game.show_guesses
    erb :play_game, :locals => {:blanks => blanks, :guesses => $game.guesses, :turns => $game.turns, :feedback => feedback}
end


get '/' do
    erb :index
end

