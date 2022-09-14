# frozen_string_literal: false

# class for loading in and managing valid words
class Dictionary
  def initialize
    @words = []
    File.open('dictionary.txt', 'r').each do |line|
      @words.push line.chomp if within_range?(line.chomp, { min: 5, max: 12 })
    end
  end

  private

  def within_range?(word, range)
    word.length >= range[:min] && word.length <= range[:max]
  end

  public

  def random_word
    @words.sample
  end
end
