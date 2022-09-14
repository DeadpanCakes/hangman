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
    puts @word

    populate_tracker
  end

  private

  def populate_tracker
    @word.split('').each { @word_tracker.push('_') }
  end

  def find_letters(letter)
    arr = @word.split('')
    test = arr.each_index.select { |i| arr[i] == letter }
    p letter
    arr.each_index.select { |i| arr[i] == letter }
  end

  def guess(letter)
    if valid_guess?(letter)
      instances = find_letters(letter)
      instances.length.positive? ? correct_guess(instances, letter) : wrong_guess(letter)
    else
      puts 'Please Only Guess Single Letters'
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
    guess.length == 1
  end

  public

  def start
    until @chances <= 0
      guess gets.chomp
      puts @word_tracker.join
    end
  end
end
