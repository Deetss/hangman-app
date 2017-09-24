require 'sinatra'
require 'sinatra/reloader' if development?
require './lib/game.rb'

enable :sessions

get '/end_game' do
    @session = session
    if @session["game"].player_won?
        feedback = "Congratulations, you've successfully guessed the word! The word was #{@session["game"].secret_word}!"
    else
        feedback = "Sorry for you bad luck! The word was #{@session["game"].secret_word}!"
    end
    erb :end_game, :locals => {:feedback => feedback}
end

get '/make_guess' do
    @session = session
    @session[:guess] = params[:guess]

    feedback = @session["game"].check_guess(@session[:guess]) unless @session[:guess].nil?
    if feedback == true || @session["game"].turns == 0 || !@session["game"].have_blanks?
        redirect '/end_game'
    end
    @session["game"].end_turn
    @session["game"].show_letter
    redirect '/play_game'
end

get '/new_game' do
    game = Game.new
    session["game"] = game
    @session = session
    p @session['game']
    #@session.delete(:guess)
    redirect '/play_game'
end

get '/play_game' do
    @session = session
    blanks = ""
    @session["game"].hidden_word.each_char do |dash|
        blanks << dash + " "
     end
    erb :play_game, :locals => {:blanks => blanks, :guesses => @session["game"].show_guesses, :turns => @session["game"].turns}
end


get '/' do
    erb :index
end

