require "./spec_helper"

record TestValue, min : UInt8, max : UInt8, low : UInt8, quarter : UInt8,
  mid : UInt8, threequarter : UInt8, full : UInt8
TestValues = [
  TestValue.new(
    min: 0_u8,
    max: 255_u8,
    low: 0,
    quarter: 0x40,
    mid: 0x7F,
    threequarter: 0xBF,
    full: 0xFF,
  ),
  TestValue.new(
    min: 0x7F_u8,
    max: 255_u8,
    low: 0x7F,
    quarter: 0xA0,
    mid: 0xBF,
    threequarter: 0xDF,
    full: 0xFF,
  ),
  TestValue.new(
    min: 0_u8,
    max: 0x7F_u8,
    low: 0,
    quarter: 0x20,
    mid: 0x40,
    threequarter: 0x5F,
    full: 0x7F,
  ),
]
COLOR_PAIRS = [
  {:green, :blue},
  {:red, :blue},
  {:green, :red},
  {:blue, :green},
  {:blue, :red},
]

module Colors
  describe Gradient do
    TestValues.each do |color|
      grad = Gradient.new :red, :green, from: color.min, upto: color.max
      it "Gets the right value at 1:2 with min  #{color.min} and max  #{color.max}" do
        grad.low_color.red?.should be_true
        grad.high_color.green?.should be_true
        grad[50].red.to_i.should be_close expected: color.mid, delta: 2
        grad[50].blue.should eq color.min
        grad[50].green.to_i.should be_close expected: color.mid, delta: 2
      end
      it "Gets the right value at 1:4 with min  #{color.min} and max  #{color.max}" do
        grad.low_color.red?.should be_true
        grad.high_color.green?.should be_true
        grad[25].red.to_i.should be_close expected: color.threequarter, delta: 2
        grad[25].blue.should eq color.min
        grad[25].green.to_i.should be_close expected: color.quarter, delta: 2
      end
      it "Gets the right value at 1:1 with min  #{color.min} and max  #{color.max}" do
        grad.low_color.red?.should be_true
        grad.high_color.green?.should be_true
        grad[100].red.should eq color.low
        grad[100].green.should eq color.full
        grad[100].blue.should eq color.low
      end
      it "Gets the right value at 0:1 with min  #{color.min} and max  #{color.max}" do
        grad.low_color.red?.should be_true
        grad.high_color.green?.should be_true
        grad[0].red.should eq color.full
        grad[0].green.should eq color.low
        grad[0].blue.should eq color.low
      end
      it "Gets the right value at 3:4 with min  #{color.min} and max  #{color.max}" do
        grad.low_color.red?.should be_true
        grad.high_color.green?.should be_true
        grad[75].red.to_i.should be_close color.quarter, delta: 1
        grad[75].green.to_i.should be_close color.threequarter, delta: 1 # (0xFF * 4 / 3)
        grad[75].blue.should eq color.low
      end
    end
    test_grad = Gradient.new
    it "iterates over the whole gradient" do
      counter = 0
      test_grad.each { counter += 1 }
      counter.should eq test_grad.max
    end
    it "iterates with an index" do
      counter = 0
      test_grad.each_with_index do |c, i|
        test_grad[i].red.should eq c.red
        test_grad[i].green.should eq c.green
        counter += 1
      end
      counter.should eq test_grad.max
    end
    it "fails to be initialized when the colors are the same" do
      expect_raises Colors::Gradient::SameColor do
        Colors::Gradient.new low_color: :red, high_color: :red
      end
    end
    it "initializes from a range" do
      grad = Colors::Gradient.new 0_i64..100_i64
      grad.low_color.red?.should be_true
      grad.high_color.green?.should be_true
      grad[0].red.should eq 0xFF
      grad[0].green.should eq 0
      grad[100].red.should eq 0
      grad[100].green.should eq 0xFF
    end
    {% for pair in COLOR_PAIRS %}
      {% low = pair[0]; high = pair[1] %}
      it "gradient from {{low.id}} to {{high.id}}" do
        grad = Colors::Gradient.new low_color: {{low}}, high_color: {{high}}
        grad.low_color.{{low.id}}?.should be_true
        grad.high_color.{{high.id}}?.should be_true
        grad[0].{{low.id}}.should eq 0xFF
        grad[0].{{high.id}}.should eq 0
        grad[100].{{low.id}}.should eq 0
        grad[100].{{high.id}}.should eq 0xFF
      end
    {% end %}
  end
end
