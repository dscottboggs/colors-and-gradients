require "./color_value"
require "./color"

def rand(type : Colors::ColorValue.class)
  type.new rand UInt8
end

def rand(type : Colors::Color.class)
  type.new rand(Colors::ColorValue), rand(Colors::ColorValue), rand(Colors::ColorValue)
end
