require "./colors/*"

# TODO: Write documentation for `Colors`
module Colors
end

Colors::Gradient.new.each_with_index do |c, i|
  print c.colorize( " i=#{i}\r" )
  sleep 0.1.seconds
end
