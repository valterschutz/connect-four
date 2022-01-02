require 'debug'

class Board
  attr_accessor :cols

  def initialize(a,height)
    # a can either be a premade board or a width
    if a.is_a?(Array)
      @cols = a
      @width = @cols.size
    elsif a.is_a?(Integer)
      @cols = (1..a).to_a.map{|num| []}
      @width = a
    else
      raise "a should always be an Array or Integer. Instead found #{a.class}"
    end
    @height = height
  end

  def winner
    vertical_1_winner = @cols.map{|col| col.each_cons(4).any?{|seq| seq==[1]*4}}.any?
    vertical_0_winner = @cols.map{|col| col.each_cons(4).any?{|seq| seq==[0]*4}}.any?
    filled = @cols.map{|col| col+[nil]*(@height-col.length)}
    transposed = filled.transpose
    horizontal_1_winner = transposed.map{|row| row.each_cons(4).any?{|seq| seq==[1]*4}}.any?
    horizontal_0_winner = transposed.map{|row| row.each_cons(4).any?{|seq| seq==[0]*4}}.any?

    return 1 if vertical_1_winner || horizontal_1_winner
    return 0 if vertical_0_winner || horizontal_0_winner

    # Check for winner on positive slope diagonal
    for i in (0..@width-4)
      for j in (0..@height-4)
        return 1 if (i..i+3).zip(j..j+3).all?{|a,b| filled[a][b]==1}
        return 0 if (i..i+3).zip(j..j+3).all?{|a,b| filled[a][b]==0}
      end
    end

    # Check for winner on negative slope diagonal
    for i in (0..@width-4)
      for j in (3..@height)
        return 1 if (i..i+3).zip(j-3..j).all?{|a,b| filled[a][b]==1}
        return 0 if (i..i+3).zip(j-3..j).all?{|a,b| filled[a][b]==0}
      end
    end

    # Return nil if no winner found
    return nil
  end

  def place(who,where)
    # assume the move is allowed
    @cols[where] << who
    return :success
  end

  def is_allowed?(col)
    @cols[col].length == @height ? false : true
  end

  def is_full?
    @cols.all?{|col| col.size == @height}
  end

  def to_s(p1_symbol='0', p2_symbol='1')
    filled = @cols.map{|col| col+[nil]*(@height-col.length)}
    transposed = filled.transpose
    return_str = transposed.map{|row| "|#{row.map{|val| val.nil? ? ' ' : val}.join('|')}|"}.reverse.join("\n")
    return_str += "\n" + ':'+(0...@width).map{|num| num.to_s}.join(':')+':'
    return return_str
  end

  # This method can use custom symbols. Note that if the symbols have
  # different widths the board will look weird
  def print_board(p1_symbol='0', p2_symbol='1')
    filled = @cols.map{|col| col.map{|num| num==0 ? p1_symbol : p2_symbol}+[nil]*(@height-col.length)}
    transposed = filled.transpose
    str = transposed.map{|row| "|#{row.map{|val| val.nil? ? ' ' : val}.join('|')}|"}.reverse.join("\n")
    str += "\n" + ':'+(0...@width).map{|num| num.to_s}.join(':')+':'
    puts str
  end
end
