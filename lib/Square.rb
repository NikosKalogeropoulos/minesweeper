class Square
  BOMB = 'B'
  HIDDEN= 'X'

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

  def to_s
    if @reveal
      return @value.to_s
    else
      return Square::HIDDEN
    end
  end

end
