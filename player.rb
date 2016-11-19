class HumanPlayer
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def prompt
    print "Make a guess: "
    gets.chomp.split(",").map(&:to_i)
  end

end


class ComputerPlayer
  attr_reader :name

  GRID_WIDTH = 5
  GRID_HEIGHT = 4

  def initialize(name = "Hank")
    @name = name
    @known_cards = Hash.new() { |h, k| h[k] = [] }
    @matched_cards = []
    @next_to_guess = nil
  end

  def receive_revealed_card(pos, card_value)
    @known_cards[card_value] << pos
  end

  def receive_match(pos1, pos2, card_value)
    @matched_cards << pos1 << pos2
    @known_cards.delete(card_value)
    @next_to_guess = nil
  end

  def revealed?(pos)
    @matched_cards.include?(pos)
  end

  def already_guessed?(pos)
    @known_cards.each do |_, v|
      return true if v.include?(pos)
    end
    false
  end

  def confirmed_pair
    @known_cards.each do |_, v|
      return v if v.length == 2
    end
    false
  end

  def random_guess
    guess = [(0...GRID_HEIGHT).to_a.sample, (0...GRID_WIDTH).to_a.sample]

    while revealed?(guess) || already_guessed?(guess)
      guess = [(0...GRID_HEIGHT).to_a.sample, (0...GRID_WIDTH).to_a.sample]
    end

    guess
  end

  def prompt
    if @next_to_guess
      to_guess = @next_to_guess
      @next_to_guess = nil
      to_guess
    elsif confirmed_pair
      @next_to_guess = confirmed_pair.last
      confirmed_pair.first
    else
      random_guess
    end
  end
end
