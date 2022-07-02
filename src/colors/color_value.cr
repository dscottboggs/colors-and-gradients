require "./any_number"

module Colors
  MAX_INTENSITY = 255_u8
  MIN_INTENSITY =   0_u8

  # The value one primary color has out of a RGB color.
  class ColorValue
    def initialize(@value : UInt8 = MIN_INTENSITY); end

    # Create a `ColorValue` from a number or another color value.
    #
    # Raises `OverflowError` if the value won't fit in a `UInt8`; I.E. if the
    # value is less than 0 or greater than 255, or not an integer; E.G. `3.0`,
    # `100u64`, `255f64`, or `ColorValue::new(100u8)` are acceptable
    # parameters, `-1`, `256u16`, or `123.456` will throw.
    def initialize(value : AnyNumber | ColorValue)
      @value = value.to_u8
    end

    # Create a `ColorValue` from a string representation: either a
    # **hexadecimal** numeric value between 0 and 255, or the words `"full"` or
    # `"off"` which translate to `MAX_INTENSITY` and `MIN_INTENSITY`,
    # respectively.
    #
    # Raises if the value isn't a valid **base-16** integer which fits into 8
    # bits, unsigned.
    def initialize(value : String = "0")
      if value == "full"
        @value = MAX_INTENSITY
      elsif value == "off"
        @value = MIN_INTENSITY
      else
        @value = value.to_i(base: 16).to_u8
      end
    end

    def self.off
      ColorValue.new MIN_INTENSITY
    end

    def self.full
      ColorValue.new MAX_INTENSITY
    end

    def self.max
      ColorValue.new MAX_INTENSITY
    end

    def self.min
      ColorValue.new MIN_INTENSITY
    end

    def to_s(io)
      io.printf "%02X", @value
    end

    def to_i
      @value.to_i
    end

    def to_u8
      @value
    end

    def to_f
      @value.to_f
    end

    # boolean operators
    {% for op in [:==, :>, :<, :<=, :>=] %}
    def {{op.id}}(other)
      @value {{op.id}} other.to_u8
    end
    {% end %}

    # regular and bitwise operators
    {% for op in [:-, :+, :*, :/, :%, :&, :|, :"^"] %}
      # Defines a new color where this color {{op.id}} other
      def {{op.id}}(other)
        ColorValue.new( @value {{ op.id }} other )
      end
    {% end %}

    def abs
      @value # unsigned so always positive
    end
  end
end
