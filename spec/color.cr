require "./spec_helper"

RGB       = [:red, :blue, :green]
Greyscale = {black: 0, white: 255, grey: 0x88, gray: 0x88}

describe Colors::Color do
  {% for col in RGB %}
  it "initializes with self.{{col.id}}" do
    # the color we're testing
    test_color = Colors::Color.{{col.id}}
    test_color.{{col.id}}.should eq 255
    # the other colors
    #color_symbol = {{col.id}}
    {% for off_col in RGB %}
      test_color.{{ off_col.id }}.should eq 0 unless {{ off_col.stringify }} == {{ col.stringify }}
    {% end %}
    random_value = Colors::ColorValue.new( rand 0...255 )
    # the color we're testing
    test_color = Colors::Color.{{col.id}} random_value
    test_color.{{col.id}}.to_u8.should eq random_value.to_u8
    # the other colors
    #color_symbol = {{col.id}}
    {% for off_col in RGB %}
      test_color.{{ off_col.id }}.should eq 0 unless {{ off_col.stringify }} == {{ col.stringify }}
    {% end %}
  end
  {% end %}
  {% for col, val in Greyscale %}
  it "intializes with self.{{col.id}}" do
    test_color = Colors::Color.{{col.id}}
    {% for rgb in RGB %}
      test_color.{{rgb.id}}.should eq {{ val }}
    {% end %}
  end
  {% end %}
  it "initializes from numbers" do
    test_color = Colors::Color.new 0x55, 0x88, 0xBB
    test_color.red.should eq 0x55
    test_color.green.should eq 0x88
    test_color.blue.should eq 0xBB
  end
  it "converts to a string" do
    Colors::Color.new(0x55, 0x88, 0xBB).to_s.should eq "#5588BB"
  end
  it "converts from a string" do
    test_color = Colors::Color.from_s "#5588BB"
    test_color.red.should eq 0x55
    test_color.green.should eq 0x88
    test_color.blue.should eq 0xBB
  end
end
