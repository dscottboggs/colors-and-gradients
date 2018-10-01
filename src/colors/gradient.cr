module Colors
  ValidColors = [:red, :green, :blue]
  class Gradient
    property min
    property max
    getter low_color
    getter high_color
    property range : Range(Int32|Int64, Int32|Int64)?
    property from
    property upto

    def initialize(
      @low_color : Symbol = :red,
      @high_color : Symbol = :green,
      @from : ColorValue | UInt8 = ColorValue.off,
      @upto : ColorValue | UInt8 = ColorValue.full,
      @max = 100,
    )
      check_colors
      @min = 0
      range = (min...max)
    end

    def initialize(
      @range : Range(Int32|Int64, Int32|Int64),
      @low_color : Symbol=:red,
      @high_color : Symbol=:green,
      @from : ColorValue | UInt8 = ColorValue.off,
      @upto : ColorValue | UInt8 = ColorValue.full,
    )
      check_colors
      @min = @range.begin
      @max = @range.end
    end
    def [](val) : Color
      value = val.to_f
      high_value = from + ((( value - min ) * ( upto.to_u8 - from.to_u8) ).to_f / ( max - min ) )
      low_value  = ColorValue.new( upto - high_value.to_u8 + from.to_u8 )
      return case @low_color
      when :red
        case @high_color
        when :green
          Color.new(
            red: ColorValue.new(low_value),
            green: ColorValue.new(high_value)
          )
        else # :blue
          Color.new(
            red: ColorValue.new(low_value),
            blue: ColorValue.new(high_value)
          )
        end
      when :green
        case @high_color
        when :red
          Color.new(
            red: ColorValue.new(high_value),
            green: ColorValue.new(low_value)
          )
        else # :blue
          Color.new(
            green: ColorValue.new(low_value),
            blue: ColorValue.new(high_value)
          )
        end
      else # :blue
        case @high_color
        when :red
          Color.new(
            red: ColorValue.new(high_value),
            blue: ColorValue.new(low_value)
          )
        else # :green
          Color.new(
            green: ColorValue.new(high_value),
            blue: ColorValue.new(low_value)
          )
        end
      end
    end
    def check_colors
      should_raise = false
      raise String.build { |ex|
        ex << "Got #{@low_color.to_s} and #{@high_color.to_s}."
        unless Colors::ValidColors.includes? @low_color && Colors::ValidColors.includes? @high_color
          ex << " Invalid color."
          should_raise = true
        end
        if @low_color == @high_color
          ex << " Colors must be different."
          should_raise = true
        end
      } if should_raise
    end
    def each
      (min...max).each { |c| yield self[c] }
    end
    def each_with_index
      (min...max).each { |c| yield self[c], c }
    end
    def map(&block : T -> U) forall U
      output = Array(U).new
      each { |c| output << yield c }
      output
    end
    def map_with_index(&block : T -> U) forall U
      output = Array(U).new
      each_with_index { |c, i| output << yield c, i }
      output
    end
  end
end
