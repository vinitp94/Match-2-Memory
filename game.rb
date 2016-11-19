require_relative 'board'
require_relative 'card'
require_relative 'player'

require 'byebug'

class Game
  attr_reader :board, :previous_guess, :guessed_pos, :player

  def initialize(player = ComputerPlayer.new("LOL"))
    @board = Board.new
    @player = player
  end

  def play
    puts "Hello, #{@player.name}!"
    @board.populate

    until over?
      2.times do
        @board.render
        @guessed_pos = @player.prompt
        make_guess(@guessed_pos)
        system("clear")
      end
    end

    @board.render
    puts "You win!"
  end

  def over?
    @board.won?
  end

  def make_guess(pos)
    player.receive_revealed_card(pos, @board.reveal(pos))
    if @previous_guess.nil?
      @previous_guess = pos
    else
      system("clear")
      @board.render
      sleep(2)
      if @board[@previous_guess] == @board[pos]
        @player.receive_match(@previous_guess, pos, @board[pos].face_value)
      else
        reset_cards
      end
      @previous_guess = nil
    end
  end

  def reset_cards
    @board[@previous_guess].hide
    @board[@guessed_pos].hide
  end

end

if __FILE__ == $PROGRAM_NAME
  new_game = Game.new
  new_game.play
end
