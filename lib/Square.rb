class Square
  BOMB = 'B'

  attr_accessor :flagged
  def initialize()
    @value = 0
    @reveal = false
    @flagged = false
  end

  def reveal
    @reveal = true unless @flagged
  end

  def has_bomb?
    @value == Square::BOMB
  end

  def place_bomb
    @value = BOMB
  end

end
