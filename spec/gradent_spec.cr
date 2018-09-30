require "./spec_helper"

module Colors
  describe Gradient do
    grad = Gradient.new :red, :green
    it "gets the right color values" do

      it "Gets the right value at 1:2" do
        grad.low_color.should eq :red
        grad.high_color.should eq :green
        grad[50].red.should be_close expected: 0x7F, delta: 2
        grad[50].blue.should eq 0
        grad[50].green.should be_close expected: 0x7F, delta: 2
      end
      it "Gets the right value at 1:4" do
        grad.low_color.should eq :red
        grad.high_color.should eq :green
        grad[25].red.to_i.should be_close expected: 0xBF, delta: 2
        grad[25].blue.should eq 0
        grad[25].green.to_i.should be_close expected: 0x40, delta: 2
      end
      it "Gets the right value at 1:1" do
        grad.low_color.should eq :red
        grad.high_color.should eq :green
        grad[100].red.should eq 0
        grad[100].green.should eq 0xFF
        grad[100].blue.should eq 0
      end
      it "Gets the right value at 0:1" do
        grad.low_color.should eq :red
        grad.high_color.should eq :green
        grad[0].red.should eq 0xFF
        grad[0].green.should eq 0
        grad[0].blue.should eq 0
      end
      it "Gets the right value at 3:4" do
        grad.low_color.should eq :red
        grad.high_color.should eq :green
        grad[75].red.to_i.should be_close 0x40, delta: 2
        grad[75].green.to_i.should be_close 0xBF, delta: 2 # (0xFF * 4 / 3)
        grad[75].blue.should eq 0
      end
    end
    it "iterates over the whole gradient" do
      counter = 0
      grad.each { counter+=1 }
      counter.should eq grad.max + 1
    end
    it "iterates with an index" do
      counter = 0
      grad.each_with_index do |c, i|
        grad[i].red.should eq c.red
        grad[i].green.should eq c.green
        counter += 1
      end
      counter.should eq grad.max + 1
    end
  end
end
