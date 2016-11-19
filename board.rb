require_relative 'card'

class Board
  CARD_DECK = ["A", 2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K"].freeze
  GRID_WIDTH = 5
  GRID_HEIGHT = 4

  attr_reader :grid

  def initialize
    @grid = Array.new(GRID_HEIGHT) { Array.new(GRID_WIDTH) }
  end

  def populate
    until full?
      random_card = CARD_DECK.sample
      2.times do
        pos = [(0...GRID_HEIGHT).to_a.sample, (0...GRID_WIDTH).to_a.sample]
        if tile_empty?(pos)
          self[pos] = Card.new(random_card)
        else
          redo
        end
      end
    end
  end

  def full?
    grid.flatten.none?(&:nil?)
  end

  def tile_empty?(pos)
    self[pos].nil?
  end

  def []=(pos, value)
    row, col = pos
    grid[row][col] = value
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def render
    puts "--------------------------"
    grid.each do |row|
      print "| "
      row.each do |card|
        if card.nil? || card.hidden
          print "   | "
        elsif card.face_value == 10
          print "#{card.face_value} | "
        else
          print " #{card.face_value} | "
        end
      end
      print "\n"
      puts "--------------------------"
    end
  end

  def won?
    grid.flatten.none?(&:hidden)
  end

  def reveal(guessed_pos)
    if self[guessed_pos].hidden
      self[guessed_pos].reveal
      self[guessed_pos].face_value
    end
  end
end
