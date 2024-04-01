# frozen_string_literal: true

# The game state for Hangman
class Game
  attr_reader :word, :guesses, :correct_letters

  def initialize
    @word = select_word
    @guesses = []
    @correct_letters = '_' * @word.length
  end

  private

  def select_word
    File.readlines('google-10000-english-no-swears.txt')
        .select { |line| line.chomp.length.between?(5, 12) }
        .sample
        .chomp
  end
end
