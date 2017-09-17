class Word
  attr_reader :scrubbed_dict, :blank_word, :random_word

  @@raw_dictionary = File.readlines("5desk.txt")

  #initialize object
  def initialize
    dictionary_exists?
    load_dictionary
    @random_word = pick_random_word(scrubbed_dict).strip
    @blank_word = hide_word(random_word)
  end

  #chooses random word from dictionary
  def pick_random_word(dictionary)
    random_num = rand(dictionary.length)
    dictionary[random_num]
  end

  #scrubs a indicated dictionary file
  def scrub_dictionary(dictionary)
    dictionary.each do |word|
      word.downcase
      unless word.length >= 5 && word.length <= 12
        dictionary.delete(word)
      end
    end
  end

  #loads a scrubbed dictionary
  def load_dictionary
    @scrubbed_dict = File.readlines("dictionary.txt")
    puts "Dictionary loaded"
  end

  #checks working dir for scrubbed dictionary
  def dictionary_exists?
    unless File.exist?("dictionary.txt")
      scrub_dictionary(@@raw_dictionary)
      create_dictionary_file(scrub_dictionary(@@raw_dictionary))
    end

  end
  
  #creates newly scrubbed dictionary file
  def create_dictionary_file(dictionary)
    dictionary_file = File.open("dictionary.txt", "w")
    dictionary_file.puts dictionary
    dictionary_file.close
  end

  #hides the chosen word for later uses
  def hide_word(chosen_word)
    blank_word = chosen_word.gsub(/\w/,"_")
  end
end
