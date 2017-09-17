require_relative "word.rb"
require "json"

class Game

  attr_accessor :current_guess
  attr_reader :turns,:guesses, :secret_word, :hidden_word, :save_data

  #initializing object
  def initialize
    @turns = 12
    @word = Word.new
    @secret_word = @word.random_word
    @hidden_word = @word.blank_word
    @guesses = []
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
    if File.exist?("save.txt")
      save_file = File.read("save.txt")
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
    save = File.new("save.txt", "w+")
    save.puts JSON::dump(save_data)
    save.close
  end

  #prompts the user to make a guess then shovels the guess into :guesses
  def make_guess
      puts "Make a guess:"
      @current_guess = gets.chomp
      unless good_guess?
        puts "That is an invalid guess, please try again!"
        @current_guess = gets.chomp
      end
      puts
      guesses << current_guess unless current_guess == "save" || current_guess == secret_word
  end

  #checks for invalid guess
  def good_guess?
    current_guess == "save" || current_guess == secret_word || current_guess.length == 1
  end
  
  #parses through the secret word to check for matching guesses, then reveals a correct guess
  #in the hidden_word string
  def show_letter
      split_blanks = hidden_word.split("")
      occurences = []
      occurences = (0 ... secret_word.length).find_all { |i| secret_word[i,1] == current_guess}
      occurences.each { |i| split_blanks[i] = current_guess}
      @hidden_word = split_blanks.join("")
      puts hidden_word
  end

  #gives feedback to the user depending on their input
  def check_guess
    if current_guess == secret_word
      player_won?
    else
      if secret_word.include? current_guess
        show_letter
        puts "This word includes the guessed letter\n\n"
      elsif current_guess == "save"
        create_save
        puts "Game saved! Exiting game!"
        exit
      else
        show_letter
        puts "This word does not include the guessed letter\n\n"
      end
    end
  end

  #shows a list of the current guesses, unless its the first turn
  def show_guesses
    puts "Guesses: #{guesses.join(" ")}\n" unless turns == 12
  end
  
  #at the end of the game the user is prompted to exit or play again
  def exit_game?
    puts "Would you like to exit game or play again?"
    decision = gets.chomp
    if decision.downcase == "exit"
      exit
    elsif decision.downcase == "play again"
      initialize
    end
  end

  #ends turn by removing one remaining turn and outputing a string showing remaining turns
  #unless there are no turns remaining then it calls exit_game?
  def end_turn
    @turns -= 1
    if turns == 0 || current_guess == secret_word
      puts "Game over! \n\nThe word was #{secret_word}"
      exit_game?
    else
      puts "Turns left: #{turns} \n\n______________________________________________"
    end
  end
  
  #checks if the hidden word still has any blanks
  def have_blanks?
    hidden_word.match("_")
  end

  #player wins if they completely guess the secret_word or there are no more blanks
  def player_won?
    if current_guess == secret_word || !have_blanks?
      puts "Congratulations! You have successfully solved the puzzle!\n"
      exit_game?
      return true
    else
      return false
    end
  end

end

game = Game.new
word = game.secret_word

game.start_game
while !game.player_won?
  game.show_guesses
  game.make_guess
  game.check_guess
  game.end_turn
  game.player_won?
end
