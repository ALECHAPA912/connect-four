require '../lib/game.rb'
require '../lib/miscellaneous.rb'

include Miscellaneous

describe Game do
  describe "#board_full?" do
  subject(:game_full) { described_class.new }
    context "when board is full" do
      before do 
        board = subject.instance_variable_get(:@board)
        board.each do |column|
          (0..5).each do |row|
            column[row] = red_token
          end
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
          (0..3).each do |row|
            column[row] = yellow_token
          end
        end
      end
      it "returns false" do
        expect(subject.board_full?).to be false
      end
    end
  end

  describe "#do_a_play" do
    subject(:game_play) { described_class.new }
    context "when user insert a invalid input, then a valid input" do
      before do
        allow(subject).to receive(:puts)
        allow(subject).to receive(:gets).and_return("carne asada", "3")
      end
      it "sends #verify_input two times and then #put_token" do
        players = subject.instance_variable_get(:@players)
        current_player = subject.instance_variable_get(:@current_player)
        expect(subject).to receive(:verify_input).with("carne asada").and_return(nil)
        expect(subject).to receive(:verify_input).with("3").and_return("3")
        expect(subject).to receive(:put_token).with(players[current_player], 2)
        subject.do_a_play
      end
    end
    context "when user insert two invalid inputs, then a valid input" do
      before do
        allow(subject).to receive(:puts)
        allow(subject).to receive(:gets).and_return("carne asada", "papas fritas", "6")
      end
      it "sends #verify_input three times and then #put_token" do
        players = subject.instance_variable_get(:@players)
        current_player = subject.instance_variable_get(:@current_player)
        expect(subject).to receive(:verify_input).with("carne asada").and_return(nil)
        expect(subject).to receive(:verify_input).with("papas fritas").and_return(nil)
        expect(subject).to receive(:verify_input).with("6").and_return("6")
        expect(subject).to receive(:put_token).with(players[current_player], 5)
        subject.do_a_play
      end
    end
  end
end