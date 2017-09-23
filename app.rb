require 'sinatra' 
require 'sinatra/reloader' if development?
require './lib/game.rb'


enable :sessions

get '/end_game' do
    if $game.player_won?
        feedback = "Congratulations, you've successfully guessed the word! The word was #{$game.secret_word}!"
    else
        feedback = "Sorry for you bad luck! The word was #{$game.secret_word}!"
    end
    erb :end_game, :locals => {:feedback => feedback}
end

get '/make_guess' do
    session[:guess] = params[:guess]
    $game.end_turn
    $game.show_letter
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
    if feedback == true || $game.turns == 0 || !$game.have_blanks?
        redirect '/end_game'
    end
    $game.hidden_word.each_char do |dash|
        blanks << dash + " "
     end
    erb :play_game, :locals => {:blanks => blanks, :guesses => $game.show_guesses, :turns => $game.turns}
end


get '/' do
    erb :index
end

