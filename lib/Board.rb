require_relative "./Square.rb"
require "byebug"

class Board
  def initialize
    @number_of_bombs= 10
    @size = 9
    @board = Array.new(@size) {Array.new(@size) {Square.new}}
    seed_board
  end

  def [](pos)
    row,col = pos
    @board[row][col]
  end

  def display
    @board.each do |row|
      row.each {|col| print "#{col} "}
      puts
    end
  end
  private
  def seed_board
    # debugger
    bombs_placed = 0
    while bombs_placed < @number_of_bombs
      pos = generate_random_position
      unless self[pos].has_bomb?
        self[pos].place_bomb
        bombs_placed += 1
      end
    end
  end

  def generate_random_position
    pos = [rand(@size), rand(@size)]
  end
end



if __FILE__ == $PROGRAM_NAME
  board = Board.new
  board.display
end

