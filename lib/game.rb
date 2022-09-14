# frozen_string_literal: false

require './lib/dictionary'

# class to store and manage game logic
class Game
  def initialize
    @dictionary = Dictionary.new
    @chances = 6
    @word = @dictionary.random_word
    @guessed_letters = []
    @correct_letters = []
    @word_tracker = []

    populate_tracker
  end

  private

  def populate_tracker
    @word.split('').each { @word_tracker.push('_') }
  end

  def find_letters(letter)
    arr = @word.split('')
    arr.each_index.select { |i| arr[i] == letter }
  end

  def guess(letter)
    if valid_guess?(letter)
      instances = find_letters(letter)
      instances.length.positive? ? correct_guess(instances, letter) : wrong_guess(letter)
      @guessed_letters.push(letter)
    else
      puts 'Please Only Guess Single Letters'
      puts "You Have Already Guessed #{@guessed_letters.join(', ')}"
    end
  end

  def fill_letter(instances, letter)
    instances.each { |i| @word_tracker[i] = letter }
  end

  def decrement_chances
    @chances -= 1
  end

  def correct_guess(instances, letter)
    puts "There were #{instances.length} #{letter}'s."
    fill_letter(instances, letter)
  end

  def wrong_guess(letter)
    decrement_chances
    puts "There is no #{letter}. #{@chances} chances left"
  end

  def valid_guess?(guess)
    guess.length == 1 && !@guessed_letters.include?(guess)
  end

  public

  def start
    until @chances <= 0 || @word_tracker.join == @word
      guess gets.chomp
      puts @word_tracker.join
    end
    puts @word_tracker.join == @word ? "You've Won!" : "You're Out Of Guesses!"
    puts "The Word Was #{@word}"
  end
end
