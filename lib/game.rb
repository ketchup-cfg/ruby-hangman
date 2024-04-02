# frozen_string_literal: true

require_relative 'serializable'

# The game state for Hangman
class Game
  include Serializable

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

  def add_guess(guess)
    (0...word.length).each do |i|
      correct_letters[i] = guess[i] if guess[i] == word[i]
    end

    @number_of_guesses += 1
  end

  def display_loop_prompt
    puts "#{correct_letters} | #{guesses_left} guesses left"
    print 'Please enter your guess: '
  end

  def play
    until guesses_left.zero?
      display_loop_prompt
      guess = gets.chomp.downcase
      add_guess(guess)

      if won?
        puts 'You won!'
        break
      end
    end

    puts "The word was #{word}"
  end

  private

  def select_word
    File.readlines('google-10000-english-no-swears.txt')
        .select { |line| line.chomp.length.between?(5, 12) }
        .sample
        .chomp
        .downcase
  end
end
