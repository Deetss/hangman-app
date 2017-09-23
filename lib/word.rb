class Word
  attr_reader :scrubbed_dict, :blank_word, :random_word

  @@raw_dictionary = File.readlines("./lib/5desk.txt")

  #initialize object
  def initialize
    dictionary_exists?
    @random_word = pick_random_word(scrubbed_dict).strip
    @blank_word = hide_word(random_word)
  end

  #checks working dir for scrubbed dictionary
  def dictionary_exists?
    unless File.exist?("./lib/dictionary.txt")
      @scrubbed_dict = scrub_dictionary(@@raw_dictionary)
      create_dictionary_file(@scrubbed_dict)
    end
    load_dictionary
  end

  #scrubs a indicated dictionary file
  def scrub_dictionary(dictionary)
    puts "Scrubbing dictionary!"
    dictionary.collect do |word|
       word.downcase!
    end
      dictionary.delete_if do |word|
        word.length <= 5 || word.length >= 10 
      end
    puts "Dictionary scrubbed!"
    dictionary
  end

  #chooses random word from dictionary
  def pick_random_word(dictionary)
    random_num = rand(dictionary.length)
    dictionary[random_num]
  end

  #loads a scrubbed dictionary
  def load_dictionary
    @scrubbed_dict = File.readlines("./lib/dictionary.txt")
    puts "Dictionary loaded"
  end

  
  #creates newly scrubbed dictionary file
  def create_dictionary_file(dictionary)
    dictionary_file = File.open("./lib/dictionary.txt", "w")
    dictionary_file.puts dictionary
    dictionary_file.close
  end

  #hides the chosen word for later uses
  def hide_word(chosen_word)
    blank_word = chosen_word.gsub(/\w/,"_")
  end
end
