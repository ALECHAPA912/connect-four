require '../lib/game.rb'

describe Game do
  describe "#board_full?" do
  subject(:game_full) { described_class.new("X", "O") }
    context "when board is full" do
      before do 
        board = subject.instance_variable_get(:@board)
        board.each do |column|
          6.times { column.push("X") }
        end
      end
      it "returns true" do
        expect(subject.board_full?).to be true
      end
    end
    context "when board is not full" do
      before do
        board = subject.instance_variable_get(:@board)
        board.each do |column|
          4.times { column.push("X") }
        end
      end
      it "returns false" do
        expect(subject.board_full?).to be false
      end
    end
  end
end