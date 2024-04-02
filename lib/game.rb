# frozen_string_literal: true

# The game state for Hangman
class Game
  MAX_GUESSES = 11

  attr_reader :word, :number_of_guesses, :correct_letters

  def initialize
    @word = select_word
    @number_of_guesses = 0
    @correct_letters = '_' * @word.length
  end

  def guesses_left
    MAX_GUESSES - @number_of_guesses
  end

  def won?
    !@correct_letters.include?('_')
  end

  def guess(guess)
    (0...word.length).each do |i|
      correct_letters[i] = guess[i] if guess[i] == word[i]
    end

    @number_of_guesses += 1
  end

  private

  def select_word
    File.readlines('google-10000-english-no-swears.txt')
        .select { |line| line.chomp.length.between?(5, 12) }
        .sample
        .chomp
  end
end
