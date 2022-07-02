module Colors
  enum ValidColor
    Red
    Green
    Blue
  end

  class Gradient
    class SameColor < Exception
      def initialize(@color : ValidColor)
        super "gradient colors must be the different; got #{color} for both colors"
      end
    end

    property min
    property max
    getter low_color
    getter high_color
    property range : Range(Int64, Int64)
    property from
    property upto

    def initialize(
      @low_color : ValidColor = :red,
      @high_color : ValidColor = :green,
      @from : ColorValue | UInt8 = ColorValue.off,
      @upto : ColorValue | UInt8 = ColorValue.full,
      @max = 100_i64
    )
      check_colors
      @min = 0_i64
      @range = min...max
    end

    def initialize(
      range : Range(Int64, Int64),
      @low_color : ValidColor = :red,
      @high_color : ValidColor = :green,
      @from : ColorValue | UInt8 = ColorValue.off,
      @upto : ColorValue | UInt8 = ColorValue.full
    )
      check_colors
      @range = range
      @min = range.begin
      @max = range.end
    end

    def [](val) : Color
      value = val.to_f
      high_value = from + (((value - min) * (upto.to_u8 - from.to_u8)).to_f / (max - min))
      low_value = ColorValue.new(upto - high_value.to_u8 + from.to_u8)
      case @low_color
      when .red?
        case @high_color
        when .green?
          Color.new(
            red: ColorValue.new(low_value),
            green: ColorValue.new(high_value),
            blue: ColorValue.new(from)
          )
        else # :blue
          Color.new(
            red: ColorValue.new(low_value),
            green: ColorValue.new(from),
            blue: ColorValue.new(high_value)
          )
        end
      when .green?
        case @high_color
        when .red?
          Color.new(
            red: ColorValue.new(high_value),
            green: ColorValue.new(low_value),
            blue: ColorValue.new(from)
          )
        else # :blue
          Color.new(
            red: ColorValue.new(from),
            green: ColorValue.new(low_value),
            blue: ColorValue.new(high_value)
          )
        end
      else # :blue
        case @high_color
        when .red?
          Color.new(
            red: ColorValue.new(high_value),
            green: ColorValue.new(from),
            blue: ColorValue.new(low_value)
          )
        else # :green
          Color.new(
            red: ColorValue.new(from),
            green: ColorValue.new(high_value),
            blue: ColorValue.new(low_value)
          )
        end
      end
    end

    def check_colors
      raise SameColor.new @low_color if @low_color == @high_color
    end

    def each
      (min...max).each { |c| yield self[c] }
    end

    include Enumerable(Color)
  end
end
