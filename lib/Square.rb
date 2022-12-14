class Square
  BOMB = "B"
  HIDDEN = "X"

  attr_accessor :flagged, :reveal
  def initialize()
    @value = 0
    @reveal = false
    @flagged = false
  end

  def reveal
    @reveal = true unless @flagged
  end

  def revealed?
    @reveal
  end

  def flagged?
    @flagged
  end

  def has_bomb?
    @value == Square::BOMB
  end

  def place_bomb
    @value = BOMB
  end

  def found_neighbor_bomb
    @value += 1
  end

  def to_s
    if @reveal
      return @value.to_s
    elsif @flagged
      return "F"
    else
      return Square::HIDDEN
    end
  end
end
