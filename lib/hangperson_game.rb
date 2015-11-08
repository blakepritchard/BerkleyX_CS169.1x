class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  attr_accessor :word, :guesses, :wrong_guesses, :word_with_guesses, :check_win_or_lose, :verbose

  def initialize()
    setDefaults
  end
  
  def initialize(word)
    setDefaults
    @word = word
  end
  
  def setDefaults
    @word ||= 'glorp'
    @guesses ||= ''
    @wrong_guesses ||= ''
    @check_win_or_lose = :play
    @verbose = false
  end
    

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end

  def guess (charGuess)
    
    raise(ArgumentError) if ''==charGuess || nil == charGuess 
    raise(ArgumentError) unless charGuess.match(/^[[:alpha:]]+$/)
    
    guess = charGuess.downcase
    answer = @word.downcase
    
    r = false
    
    if @verbose then 
      puts "Word=#{@word}, Guess=#{charGuess}"
      puts "BeginState: Guesses=#{@guesses}, and WrongGuesses=#{@wrong_guesses}"
    end
  
    if answer.include? guess
      if (@guesses.include? guess)  
        puts "Guesses Already Includes current Guess" if @verbose
        r = false
      else
        puts "Adding Correct Guess" if @verbose
        @guesses += charGuess
        r = true
      end
      
    else
      if @wrong_guesses.include? guess 
        puts "WrongGuesses Alreaddy Includes current Guess" if @verbose
        r = false
      else
        @wrong_guesses+= charGuess
        r = true
      end
      
      
    end
    

    
    # Set Display
    display_string = ""
    answer.each_char do |letter|
      if @guesses.include? letter
        display_string += letter
      else
        display_string += '-'
      end
    
    end
    puts display_string
    @word_with_guesses = display_string
    
    

    # Set Game Status
    num_unique_chars = answer.chars.to_a.uniq.length    
    if @guesses.length >= num_unique_chars
      @check_win_or_lose = :win
    elsif @wrong_guesses.length >= 7
      @check_win_or_lose = :lose
    else
      @check_win_or_lose = :play
    end 
        

    
    # Log
    if @verbose then
      print "EndState: Guesses=#{@guesses}, "
      print " and WrongGuesses=#{@wrong_guesses}; "
      print "AnswerLength= #{num_unique_chars}, NumCorrect= #{@guesses.length}, NumWrong=#{@wrong_guesses.length}"
      puts " Returning: #{r}"  
      puts "============================================"
    end
    
    
    return r
  end



end
