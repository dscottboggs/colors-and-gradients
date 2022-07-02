require "json"
require "colorize"
require "./any_number"

module Colors
  class Color
    property red
    property green
    property blue

    def initialize(
      red : AnyNumber | ColorValue = ColorValue.off,
      green : AnyNumber | ColorValue = ColorValue.off,
      blue : AnyNumber | ColorValue = ColorValue.off
    )
      @red = ColorValue.new red
      @green = ColorValue.new green
      @blue = ColorValue.new blue
    end

    # Accepts a string like "#RRGGBB", returns a new Color. Raises an exception
    # if the string is not in that format.
    def self.from_s(string : String) : Color
      unless string[0] == '#'
        raise ArgumentError.new(
          "invalid character in color string at position 0: #{string[0]}"
        )
      end
      self.new(
        red: ColorValue.new(string[1..2]),
        green: ColorValue.new(string[3..4]),
        blue: ColorValue.new(string[5..6])
      )
    end

    def self.random
      rand self
    end

    # A `Color` with `@red` set to the given value and the other colors off.
    def self.red(intensity : AnyNumber | ColorValue = ColorValue.full)
      self.new red: ColorValue.new intensity
    end

    # A `Color` with `@blue` set to the given value and the other colors off.
    def self.blue(intensity : AnyNumber | ColorValue = ColorValue.full)
      self.new blue: ColorValue.new intensity
    end

    # A `Color` with `@green` set to the given value and the other colors off.
    def self.green(intensity : AnyNumber | ColorValue = ColorValue.full)
      self.new green: ColorValue.new intensity
    end

    # A zero `Color`.
    def self.black
      self.new
    end

    # :ditto:
    def self.zero
      black
    end

    # A `Color` with all values set to the maximum.
    def self.white
      self.grey ColorValue.max
    end

    # A `Color` where each primary color's value is equal.
    def self.grey(intensity : AnyNumber | ColorValue = ColorValue.new(0x88))
      intensity = ColorValue.new intensity
      self.new(red: intensity, blue: intensity, green: intensity)
    end

    # :ditto:
    def self.gray(intensity : AnyNumber | ColorValue = ColorValue.new(0x88))
      self.grey intensity
    end

    # Return the given text as a colorized value for display in terminals.
    def colorize(text : String)
      text.colorize(
        Colorize::ColorRGB.new(
          red: @red.to_u8,
          green: @green.to_u8,
          blue: @blue.to_u8
        )
      ).to_s
    end

    # Return the standard `#XXXXXX` hexadecimal representation of this `Color`
    def to_s
      "#" + @red.to_s + @green.to_s + @blue.to_s
    end

    def to_json
      %<"#{to_s}">
    end

    def to_json(builder)
      builder.string to_s
    end

    def self.new(pull parser : JSON::PullParser)
      self.from_s parser.read_string
    end
  end
end
