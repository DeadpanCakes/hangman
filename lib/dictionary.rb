# frozen_string_literal: false

# class for loading in and managing valid words
class Dictionary
  attr_reader :words

  def initialize
    @words = []
    File.open('dictionary.txt', 'r').each do |line|
      @words.push line.chomp if line.chomp.length >= 5 && line.chomp.length <= 12
    end
  end
end
