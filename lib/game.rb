require_relative "word.rb"
require "json"

class Game

  attr_accessor :current_guess, :guesses
  attr_reader :turns, :hidden_word, :save_data, :feedback

  #initializing object
  def initialize
    @turns = 12
    word = Word.new
    @secret_word = word.random_word
    @hidden_word = word.blank_word
    @guesses = []
    @feedback = ""
    @current_guess = ""
  end

  #Gives the player the choice to choose a save or start a new game
  def start_game
    puts "What would you like to do?"
    puts "1. Load Saved Game"
    puts "2. Start New Game"
    choice = gets.chomp
    if choice == "1"
      find_save_file
    elsif choice == "2"
      initialize
    end
  end
  
  #looks for "save.txt" in the working directory, returns string if no save present
  def find_save_file
    if File.exist?("./lib/save.txt")
      save_file = File.read("./lib/save.txt")
      load_save(save_file)
    else
      puts "No save found!"
    end
  end

  #loads save file and sets instance variables to saved state
  def load_save(save)
    save_data = JSON::load(save)
    save_data.each do |var, val|
      instance_variable_set("@" + var, save_data[var])
    end
    puts "Loaded Save!"
  end

  #serializes the current object, creates a save file, then exits game
  def create_save
    @save_data = {:turns => @turns,:guesses => @guesses,:secret_word => @secret_word, :hidden_word => @hidden_word}
    save = File.new("./lib/save.txt", "w+")
    save.puts JSON::dump(save_data)
    save.close
  end
  
  #parses through the secret word to check for matching guesses, then reveals a correct guess
  #in the hidden_word string
  def show_letter
      split_blanks = hidden_word.split(" ")
      occurences = []
      occurences = (0 ... @secret_word.length).find_all { |i| @secret_word[i,1] == @current_guess}
      occurences.each { |i| split_blanks[i] = @current_guess}
      @hidden_word = split_blanks.join(" ")
      hidden_word
  end

  #gives feedback to the user depending on their input
  def check_guess(guess)
    @current_guess = guess.downcase
    if @current_guess == @secret_word
      player_won?
    elsif @current_guess.length > 1 || @current_guess.nil?
      @feedback = "Invalid Guess!"
    else
      @feedback = ""
      if @secret_word.include? @current_guess
        show_letter
      else
        @turns -= 1
      end
      @guesses << @current_guess
    end
  end

  #shows a list of the current guesses, unless its the first turn
  def show_guesses
    @guesses.join(" ")
  end

  #ends turn by removing one remaining turn and outputing a string showing remaining turns
  #unless there are no turns remaining then it calls exit_game?
  def end_turn
     if @turns < 1 || current_guess == @secret_word
       player_won?
     end
  end
  
  #checks if the hidden word still has any blanks
  def have_blanks?
    @hidden_word.match("_")
  end

  #player wins if they completely guess the @secret_word or there are no more blanks
  def player_won?
    if current_guess == @secret_word || !have_blanks?
      return true
    else
      return false
    end
  end

end

# game = Game.new
# word = game.@secret_word
# game.start_game
# while !game.player_won?
#   game.show_guesses
# end
