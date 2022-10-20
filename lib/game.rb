# frozen_string_literal: false

require './lib/dictionary'
require 'json'

# class to store and manage game logic
class Game
  def initialize
    @dictionary = Dictionary.new
    @chances = 6
    @word = @dictionary.random_word
    @guessed_letters = []
    @correct_letters = []
    @word_tracker = []
    @game_over = false

    populate_tracker
  end

  private

  def game_over?
    @game_over
  end

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
      end_turn(letter)
    else
      puts 'Please Only Guess Single Letters'
      puts "You Have Already Guessed #{@guessed_letters.join(', ')}"
    end
  end

  def end_turn(letter)
    @guessed_letters.push(letter)
    puts @word_tracker.join(' ')
    if @chances <= 0 || @word_tracker.join == @word
      @game_over = true
      end_message(@word_tracker.join == @word ? 'won' : 'lost')
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

  def to_json(*_args)
    JSON.dump({
                chances: @chances,
                word: @word,
                guessed_letters: @guessed_letters,
                word_tracker: @word_tracker
              })
  end

  public

  def save
    puts 'What Do You Wish To Name Your File?'
    Dir.mkdir('saves') unless Dir.exist?('saves')
    File.open("./saves/#{gets.chomp}.json", 'w') { |file| file.write(to_json) }
    @game_over = true
    end_message('saved')
  end

  def load(filename)
    File.open("./saves/#{filename}.json", 'r') do |file|
      state = JSON.parse(file.read)
      @word = state['word']
      @word_tracker = state['word_tracker']
      @chances = state['chances']
      @guessed_letters = state['guessed_letters']
    end
    puts 'File Loaded'
  end

  def take_command
    puts 'Enter a letter to guess, or save/load to save/load'
    command = gets.chomp.downcase
    if command == 'save'
      save
    elsif command == 'load'
      puts 'Enter Filename'
      load(gets.chomp)
    else
      guess command
    end
  end

  def end_message(state)
    puts 'Game Has Been Saved' if state == 'saved'
    puts "You're Out Of Guesses! The Word Was #{@word}" if state == 'lost'
    puts "You've Won! The Word Was #{@word}" if state == 'won'
  end

  def start
    take_command until game_over?
  end
end
