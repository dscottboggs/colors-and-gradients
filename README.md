# colors and gradients

This is a library focused on working with colors and gradients. At this stage
it allows you to create an RGB gradient.

### New!
This shard now features [100% test coverage](https://dscottboggs.github.io/colors-and-gradients/coverage/index.html)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  colors:
    github: dscottboggs/colors-and-gradients
```

## Usage

```crystal
require "colors"

include Colors

red = Color.red
green = Color.new red: 0, green: 0xFF, blue: 0
gray = Color.gray 0x55

color_based_on_percent = Gradient.new :red, :green, 100

color = color_based_on_percent[50] # => Color red: 127, green: 127, blue: 0
color.to_s                         # => "#7F7F00"
```

Full documentation can be found [here](https://dscottboggs.github.io/colors-and-gradients/)

## Development

It's crystal, just check out the repo.

## Contributing

1. Fork it (<https://github.com/dscottboggs/colors/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [dscottboggs](https://github.com/dscottboggs) D. Scott Boggs - creator, maintainer
