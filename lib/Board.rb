require_relative "./Square.rb"
require "byebug"

class Board
  def initialize
    @number_of_bombs = 10
    @size = 9
    @board = Array.new(@size) { Array.new(@size) { Square.new } }
    seed_board
  end

  def play_game
    self.display
    loop do
      action, position = prompt
      case action
      when "f"
        flag_bomb(position)
      when "r"
        reveal(position)
      else
        puts "wrong input"
      end
      self.display
      puts "congrats mate" if won?
    end
  end

  def won?
    @board.each do |row|
      row.each do |square|
        next if square.has_bomb?
        return false if not square.revealed?
      end
    end
  end

  # user gives input as "f 1 2" or "r 1 2" where f is flag and r is reveal
  # doesn't check for correct input
  def prompt
    puts "Give an input (ex f/r 1 2)"
    input = gets.chomp.split(" ")
    pos = [input[1].to_i, input[2].to_i]
    action = input[0].downcase
    [action, pos]
  end

  def [](pos)
    row, col = pos
    @board[row][col]
  end

  def display
    @board.each do |row|
      row.each { |square| print "#{square} " }
      puts
    end
  end

  def display_lose
    @board.each do |row|
      row.each do |square|
        square.reveal = true if square.has_bomb?
        print "#{square} "
      end
      puts
    end
  end

  def reveal(square_pos)
    square = self[square_pos]
    return if self[square_pos].flagged?
    game_over if square.has_bomb?
    reveal_squares(square_pos)
  end

  def flag_bomb(square_pos)
    return if self[square_pos].revealed?

    self[square_pos].flagged = !self[square_pos].flagged
  end

  def game_over
    puts "You've lost the game"
    display_lose
    exit
  end

  # Using breadth first to search for all the squares that are to be revealed
  def reveal_squares(square_pos)
    squares_seen = [square_pos]
    queue = [square_pos]
    while not queue.empty?
      square_pos = queue[0]
      self[square_pos].reveal
      if find_neighbor_squares(square_pos, squares_seen)
        neighbor_squares = find_neighbor_squares(square_pos, squares_seen)
        queue += neighbor_squares
        squares_seen += neighbor_squares
      end
      queue.shift
    end
  end

  def find_neighbor_squares(square_pos, squares_seen)
    neighbor_squares = []
    current_square_row, current_square_col = square_pos
    row_range, col_range = valid_range(square_pos)
    row_range.each do |idx|
      col_range.each do |ydx|
        neighbor_square_position = [
          current_square_row + idx,
          current_square_col + ydx
        ]
        # if one neighbor square has a bomb then we don't want to reveal any squares, so we return nothing
        return if self[neighbor_square_position].has_bomb?
        # if square_pos is the same as neighbor_square_position next loop or if we've seen already this square check for another neighbor
        if square_pos.equal?(self[neighbor_square_position]) ||
             squares_seen.include?(neighbor_square_position)
          next
        end
        neighbor_squares << [current_square_row + idx, current_square_col + ydx]
      end
    end
    neighbor_squares
  end

  private

  def seed_board
    bombs_placed = 0
    while bombs_placed < @number_of_bombs
      pos = generate_random_position
      unless self[pos].has_bomb?
        self[pos].place_bomb
        bombs_placed += 1
      end
    end
    place_numbered_tiles
  end

  def place_numbered_tiles
    board_row_pos = 0
    while board_row_pos < @size
      board_col_pos = 0
      while board_col_pos < @size
        find_neighbor_bombs([board_row_pos, board_col_pos])
        board_col_pos += 1
      end
      board_row_pos += 1
    end
  end

  def find_neighbor_bombs(square_pos)
    current_square = self[square_pos]
    return if current_square.has_bomb?

    current_square_row, current_square_col = square_pos
    row_range, col_range = valid_range(square_pos)

    row_range.each do |row_idx|
      col_range.each do |col_idx|
        neighbor_square =
          @board[current_square_row + row_idx][current_square_col + col_idx]
        # ignore if we compare the same square
        next if neighbor_square.equal?(current_square)
        current_square.found_neighbor_bomb if neighbor_square.has_bomb?
      end
    end
  end

  def valid_range(square_pos)
    current_square_row, current_square_col = square_pos
    row_range = (-1..1)
    col_range = (-1..1)
    # first row, lower is out of bounds
    if current_square_row == 0
      row_range = (0..1)
      # last row, higher is out of bounds
    elsif current_square_row == @size - 1
      row_range = (-1...1)
    end
    # first col, lower is out of bounds
    if current_square_col == 0
      col_range = (0..1)
      # last col, higher is out of bounds
    elsif current_square_col == @size - 1
      col_range = (-1...1)
    end
    [row_range, col_range]
  end

  def generate_random_position
    pos = [rand(@size), rand(@size)]
  end
end

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  board.play_game
end
