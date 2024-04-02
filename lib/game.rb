# frozen_string_literal: true

require_relative 'serializable'

# The game state for Hangman
class Game
  include Serializable

  MAX_GUESSES = 11

  attr_reader :paused, :word, :number_of_guesses, :correct_letters

  def initialize
    @paused = false
    @word = select_word
    @number_of_guesses = 0
    @correct_letters = '_' * @word.length
  end

  def play
    start_prompt

    until guesses_left.zero?
      display_loop_prompt
      input = gets.chomp.downcase

      if input == '!'
        save_game
        @paused = true
        break
      else
        add_guess(input)
      end

      if won?
        puts 'You won!'
        break
      end
    end

    puts "The word was #{word}" unless paused
  end

  private

  def start_prompt
    return unless File.exist?('data')

    loop do
      puts 'Load previous game? (y)es or (no)?'
      input = gets.chomp[0].downcase

      case input
      when 'y'
        load_game
        break
      when 'n'
        delete_game
        break
      else
        puts 'invalid input'
      end
    end
  end

  def save_game
    File.open('data', 'w') { |f| f << serialize }
  end

  def delete_game
    File.delete('data')
  end

  def load_game
    unserialize(File.read('data'))
    delete_game
  end

  def select_word
    File.readlines('google-10000-english-no-swears.txt')
        .select { |line| line.chomp.length.between?(5, 12) }
        .sample
        .chomp
        .downcase
  end

  def display_loop_prompt
    puts "#{correct_letters} | #{guesses_left} guesses left"
    print 'Please enter your guess or enter ! to save and exit: '
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

  def guesses_left
    MAX_GUESSES - @number_of_guesses
  end
end
