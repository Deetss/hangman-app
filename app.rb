require "bundler/setup"
require 'sinatra'
require 'sinatra/reloader' if development?
require './lib/game.rb'

enable :sessions

before do
    @session = session
    @session[:guess] = params[:guess]
end

get '/end_game' do
    feedback = @session["game"].game_over
    erb :end_game, :locals => { :feedback => feedback}
end

post "/play_game" do
    feedback = @session["game"].check_guess(@session[:guess]) unless @session[:guess].nil?
    if feedback == true || @session["game"].turns == 0 || !@session["game"].have_blanks?
        redirect '/end_game'
    end
    @session["game"].end_turn
    @session["game"].show_letter
    erb :play_game, :locals => {
      blanks: @session["game"].hidden_word,
      guesses: @session["game"].show_guesses,
      turns: @session["game"].turns,
      feedback: @session['game'].feedback
    }
end

get '/new_game' do
    game = Game.new
    session["game"] = game
    p @session['game']
    redirect '/play_game'
end

get '/play_game' do
    if @session["game"].nil?
        redirect '/new_game'
    end
    erb :play_game, :locals => {:blanks => @session["game"].hidden_word, :guesses => @session["game"].show_guesses, :turns => @session["game"].turns, :feedback => @session['game'].feedback}
end


get '/' do
    erb :index
end
