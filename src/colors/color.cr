require "colorize"

module Colors
  class Color
    property red
    property green
    property blue

    def initialize(
      red : UInt8 | Int | ColorValue = ColorValue.off,
      green : UInt8 | Int | ColorValue = ColorValue.off,
      blue : UInt8 | Int | ColorValue = ColorValue.off
    )
      @red = ColorValue.new red
      @green = ColorValue.new green
      @blue = ColorValue.new blue
    end

    # Accepts a string like "#RRGGBB", returns a new Color. Raises an exception
    # if the string is not in that format.
    def self.from_s(string : String) : Color
      unless string[0] == '#'
        raise Exception.new(
          "invalid character in color string at position 0: #{string[0]}"
        )
      end
      self.new(
        red: ColorValue.new(string[1..2]),
        green: ColorValue.new(string[3..4]),
        blue: ColorValue.new(string[5..6])
      )
    end

    def self.red(intensity : ColorValue = ColorValue.full)
      self.new red: intensity
    end

    def self.blue(intensity : ColorValue = ColorValue.full)
      self.new blue: intensity
    end

    def self.green(intensity : ColorValue = ColorValue.full)
      self.new green: intensity
    end

    def self.black
      self.new
    end

    def self.white
      self.grey ColorValue.max
    end

    def self.grey(intensity : ColorValue = ColorValue.new(0x88))
      self.new(red: intensity, blue: intensity, green: intensity)
    end

    def self.gray(intensity : ColorValue = ColorValue.new(0x88))
      self.grey intensity
    end

    def colorize(text : String)
      text.colorize(
        Colorize::ColorRGB.new(
          red: @red.to_u8,
          green: @green.to_u8,
          blue: @blue.to_u8
        )
      ).to_s
    end

    def to_s
      "#" + @red.to_s + @green.to_s + @blue.to_s
    end

	def to_json
      %<"#{to_s}">
	end
	def to_json(builder)
      builder.string to_s
	end
  end
end
