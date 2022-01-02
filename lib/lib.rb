class Board
  attr_accessor :cols

  def initialize(width,height)
    @cols = (1..width).to_a.map{|num| []}
    @width = width
    @height = height
  end

  def winner
    vertical_1_winner = @cols.map{|col| col.each_cons(4).any?{|seq| seq==[1]*4}}.any?
    vertical_0_winner = @cols.map{|col| col.each_cons(4).any?{|seq| seq==[0]*4}}.any?
    filled = @cols.map{|col| col.concat([nil]*(@height-col.length))}
    transposed = filled.transpose
    horizontal_1_winner = transposed.map{|row| row.each_cons(4).any?{|seq| seq==[1]*4}}.any?
    horizontal_0_winner = transposed.map{|row| row.each_cons(4).any?{|seq| seq==[0]*4}}.any?

    return 1 if vertical_1_winner || horizontal_1_winner
    return 0 if vertical_0_winner || horizontal_0_winner

    # Check for winner on positive slope diagonal
    for i in (0..@width-4)
      for j in (0..@height-4)
        return 1 if (i..i+3).zip(j..j+3).any?{|a,b| filled[a][b]==1}
        return 0 if (i..i+3).zip(j..j+3).any?{|a,b| filled[a][b]==0}
      end
    end

    # Check for winner on negative slope diagonal
    for i in (0..@width-4)
      for j in (3..@height)
        return 1 if (i..i+3).zip(j-3..j).any?{|a,b| filled[a][b]==1}
        return 0 if (i..i+3).zip(j-3..j).any?{|a,b| filled[a][b]==0}
      end
    end

    # Return nil if no winner found
    return nil
  end

  def place(who,where)
    if @cols[where].length == @height
      return nil
    else
      @cols[where] << who
      return :success
    end
  end

end
