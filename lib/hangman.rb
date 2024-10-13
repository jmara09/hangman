require 'yaml'

class Hangman
  attr_accessor :list_of_words, :word, :user_guess, :char, :user

  def initialize(words)
    @list_of_words = words
    @wrong_letters = []
  end

  def generate_word
    loop do
      @word = @list_of_words[Random.rand(@list_of_words.length)]
      if @word.length.between?(5, 12)
        @user_guess = Array.new(@word.length, '_')
        return @word
      end
    end
  end

  def start
    greetings
    loop do
      user_input
      break if @char == 'save'

      guess_the_word(@char)
      if @wrong_letters.length == 8
        puts 'You lose'
        break puts "The correct word is #{@word}"
      end

      if @word == @user_guess.join
        puts 'You win'
        break puts @user_guess.join(' ')
      end
    end
  end

  def greetings
    generate_word
    print 'Please enter your name: '
    @user = gets.chomp
    return unless File.exist?("saved_files/#{user}.yaml")

    print 'File save detected. Do you want to load it? (y/n)'
    loop do
      @inp = gets.chomp.downcase
      unless @inp == 'y' || @inp == 'n'
        puts 'Invalid keyword'
        redo
      end

      return load if @inp == 'y'

      break
    end
  end

  def guess_the_word(char)
    unless @word.include?(char)
      @wrong_letters << char
      puts 'Oops! Try again.'
      return puts
    end

    @word.chars.each_with_index do |chr, index|
      @user_guess[index] = char if chr == char
    end
  end

  def user_input
    puts @user_guess.join(' ')
    loop do
      puts "Wrong letters: #{@wrong_letters.join(', ')}" unless @wrong_letters.empty?
      puts "Type 'save' if you want to save and continue later"
      print 'Choose a letter: '
      @char = gets.chomp.downcase
      puts
      if @char == 'save'
        to_yaml
        save
        break
      end

      unless @char.length == 1 && ('a'..'z').include?(@char) && !@wrong_letters.include?(@char)
        puts 'Invalid guess. Please try again'
        puts
        redo
      end

      return @char
    end
  end

  def to_yaml
    YAML.dump({
                user: @user,
                word: @word,
                guesses: @user_guess,
                wrong_chars: @wrong_letters
              })
  end

  def save
    @file_name = "saved_files/#{@user}.yaml"
    File.open(@file_name, 'w') do |file|
      file.puts to_yaml
    end
  end

  def load
    @file_name = "saved_files/#{@user}.yaml"
    @data = YAML.load_file(@file_name)
    @word = @data[:word]
    @user_guess = @data[:guesses]
    @wrong_letters = @data[:wrong_chars]
  end
end
