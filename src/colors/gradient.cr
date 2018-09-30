module Colors
  ValidColors = [:red, :green, :blue]
  class Gradient
    property min
    property max
    getter low_color
    getter high_color
    property range

    def initialize(
      @low_color : Symbol = :red, @high_color : Symbol = :green, @max = 100
    )
      check_colors
      @min = 0
      @range = (@min...@max)
    end

    def initialize(@low_color : Color, @high_color : Color, @range : Range(Int, Int))
      check_colors
      @min = @range.begin
      @max = @range.end
    end
    def [](val) : Color
      value = val.to_f
      high_value = ((value - min) * 0xFF).to_f / (@max - @min).to_f
      low_value  = 0xFF - high_value
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
      (min..max).each { |c| yield self[c] }
    end
    def each_with_index
      (min..max).each { |c| yield self[c], c }
    end
  end
end
