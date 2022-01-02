require_relative '../lib/board.rb'

describe Board do
  context 'when creating an empty 6x7 board' do
    subject{described_class.new(7,6)}
    it 'contains 7 empty column arrays' do
      expect(subject.cols).to eql((1..7).to_a.map{|num| []})
    end

    it 'has no winner' do
      expect(subject.winner).to eql(nil)
    end

    it 'responds to placement of discs' do
      # Place disc 0 in second column
      subject.place(0,1)
      match = (1..7).to_a.map{|num| []}
      match[1] << 0
      expect(subject.cols).to eql(match)
    end

    it 'has winner 0 after placement of 0 at bottom' do
      subject.place(0,0)
      subject.place(0,1)
      subject.place(0,2)
      subject.place(0,3)
      expect(subject.winner).to eql(0)
    end

    it 'has winner 1 after placement of 1 at bottom' do
      subject.place(1,0)
      subject.place(1,1)
      subject.place(1,2)
      subject.place(1,3)
      expect(subject.winner).to eql(1)
    end
  end

  context 'when creating a sparse board from columns' do
    subject{described_class.new([
      [],
      [0,1],
      [],
      [1,0],
      [0,0],
      [1],
      []
    ], 6)}

    it 'has no winner' do
      expect(subject.winner).to eql(nil)
    end
  end

  context 'when creating an almost full board from columns' do
    subject{described_class.new([[0,1,0,1,0]]*7,6)}

    it 'does allow placement once in a column' do
      expect(subject.is_allowed?(3)).to eql(true)
    end

    it 'does not allow placement twice in a column' do
      subject.place(1,3)
      expect(subject.is_allowed?(3)).to eql(false)
    end
  end

  context 'when creating boards without winner' do
    it 'detects scenario 1' do
      board = Board.new([
        [],
        [0],
        [1,0],
        [0,1,0],
        [0,1,0],
        [1,1],
        []
      ],6)
      expect(board.winner).to eql(nil)
    end

    it 'detects scenario 2' do
      board = Board.new([
        [],
        [0,0,1],
        [1,0,0],
        [0,1,0],
        [0,1,0,1,1],
        [1,1,1,0],
        []
      ],6)
      expect(board.winner).to eql(nil)
    end

    it 'detects scenario 3' do
      board = Board.new([
        [0],
        [0,0,1,0],
        [1,0,0,0,1],
        [0,1,0,1],
        [0,1,0,1,1],
        [1,1,1,0],
        [1,0]
      ],6)
      expect(board.winner).to eql(nil)
    end
  end

  context 'when creating boards with winners' do
    it 'detects scenario 1' do
      # horizontal 1s
      board = Board.new([
        [0],
        [0,0,1,0,1],
        [1,0,0,0,1,0],
        [0,1,0,1,1],
        [0,1,0,1,1],
        [1,1,1,0],
        [1,0]
      ],6)
      expect(board.winner).to eql(1)
    end

    it 'detects scenario 2' do
      # diagonal 0s
      board = Board.new([
        [],
        [0],
        [1,0],
        [1,1,0],
        [1,1,1,0],
        [],
        []
      ],6)
      expect(board.winner).to eql(0)
    end

    it 'detects scenario 3' do
      # vertical 1s
      board = Board.new([
        [],
        [1,0,1,1,1,1],
        [0,0,1],
        [1,1],
        [0,0,0],
        [],
        []
      ],6)
      expect(board.winner).to eql(1)
    end
  end
end
