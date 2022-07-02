require "./spec_helper"

describe Colors::ColorValue do
  it "provides comparators" do
    (Colors::ColorValue.new(5) == 5).should be_true
    (Colors::ColorValue.new(5) > 4).should be_true
    (Colors::ColorValue.new(5) < 6).should be_true
    (Colors::ColorValue.new(5) <= 5).should be_true
    (Colors::ColorValue.new(5) >= 5).should be_true
  end
  it "returns the right values for classmethod getters" do
    Colors::ColorValue.off.should eq 0
    Colors::ColorValue.full.should eq 255
    Colors::ColorValue.max.should eq 255
    Colors::ColorValue.min.should eq 0
  end
  it "correctly converts to other types" do
    value = rand 0x10..0xFF
    test_color = Colors::ColorValue.new value
    test_color.to_i.should eq value
    test_color.to_u8.should eq value.to_u8
    test_color.to_f.should eq value.to_f
    test_color.to_s.should eq value.to_s(base: 16).upcase
    test_color.to_s.should eq sprintf "%02X", value.to_u8
    "#{test_color}".should eq test_color.to_s
    value = rand 0...0x10
    test_color = Colors::ColorValue.new(value)
    test_color.to_s.should eq sprintf "%02X", value.to_u8
    test_color.to_s.should eq "0" + value.to_s(base: 16).upcase
    "#{test_color}".should eq test_color.to_s
  end
  {% for op in [:-, :+, :*, :/, :%, :&, :|, :"^"] %}
  it "responds properly to the '{{op.id}}' operator" do
    color = ( rand 15 ) + 50 # random number between 50 and 65
    modifier = 2 # won't mess up any of the operator tests 🤞
    (Colors::ColorValue.new(color) {{ op.id }} modifier).should eq (color {{ op.id }} modifier)
  end
  {% end %}
  it "returns the value for the `#abs` method" do
    value = rand UInt8
    Colors::ColorValue.new(value).abs.should eq value
  end
  it "constructs from a string" do
    Colors::ColorValue.new("05").should eq 5
    expect_raises ArgumentError do
      Colors::ColorValue.new("0x50").should eq 0x50
    end
    Colors::ColorValue.new("EF").should eq 0xEF
    expect_raises OverflowError do
      Colors::ColorValue.new "BAD"
    end
    Colors::ColorValue.new("off").should eq 0
    Colors::ColorValue.new("full").should eq 0xFF
  end
end
