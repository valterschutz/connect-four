require_relative './lib/board.rb'

class NotInRangeError < StandardError
end

class ColumnFullError < StandardError
end

class SmallWidthError < StandardError
end

class SmallHeightError < StandardError
end

puts "Welcome to Connect Four."
begin
  print "Enter width of board: "
  width = Integer(gets.chomp)
  if width<4
    raise SmallWidthError
  end
rescue ArgumentError
  puts "Input not a number. Try again."
  retry
rescue SmallWidthError
  puts "Width too small. Try again."
  retry
end

begin
  print "Enter height of board: "
  height = Integer(gets.chomp)
  if height<4
    raise SmallHeightError
  end
rescue ArgumentError
  puts "Input not a number. Try again."
  retry
rescue SmallHeightError
  puts "Height too small. Try again."
  retry
end

board = Board.new(width,height)

print "Player 1, please enter your symbol of choice: "
p1_symbol = gets.chomp
print "Player 2, please enter your symbol of choice: "
p2_symbol = gets.chomp

puts "Good luck. Type 'q' at any time to quit"

until board.winner != nil || board.is_full?
  turn = turn == 0 ? 1 : 0
  board.print_board(p1_symbol,p2_symbol)
  begin
    print "It is #{turn==0 ? p1_symbol : p2_symbol}s turn. Enter column to drop a disc (0-#{width-1}): "
    input = gets.chomp
    if input == 'q'
      break
    end
    col = Integer(input)
    if !(col >= 0 && col < width)
      raise NotInRangeError
    end

    if !board.is_allowed?(col)
      raise ColumnFullError
    end
  rescue ArgumentError
    puts "Input not a number. Try again."
    retry
  rescue NotInRangeError
    puts "Input not in allowed range. Try again."
    retry
  rescue ColumnFullError
    puts "That column is full. Try again."
    retry
  end

  board.place(turn,col)
end

if board.winner != nil
  board.print_board(p1_symbol,p2_symbol)
  puts "#{turn==0 ? p1_symbol : p2_symbol} won!"
elsif board.is_full?
  board.print_board(p1_symbol,p2_symbol)
  puts "Tie!"
end
