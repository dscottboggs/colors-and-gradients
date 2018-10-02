integer_types = [
  Int, Int8, UInt8, Int16, UInt16, Int32, UInt32, Int64, UInt64,
]

module Colors
  MAX_INTENSITY = 255_u8
  MIN_INTENSITY =   0_u8

  class ColorValue
    def initialize(@value : UInt8 = MIN_INTENSITY); end

    def initialize( value : Int | Float | String | ColorValue )
      @value = value.to_u8
    end

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

    def to_s
      sprintf "%02X", @value
    end

    def to_i
      @value.to_i
    end

    def to_u8
      @value
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
