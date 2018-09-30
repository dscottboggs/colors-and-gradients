# colors

This is a library focused on working with colors and gradients. At this stage
it allows you to create an RGB gradient.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  colors:
    github: dscottboggs/colors
```

## Usage

```crystal
require "colors"

include Colors

red = Color.red
green = Color.new red: 0, green: 0xFF, blue: 0
gray = Color.gray 0x55

color_based_on_percent = Gradient.new :red, :green, 100

color_based_on_percent[50] # => Color red: 127, green: 127, blue: 0
```

## Development

It's crystal, just check out the repo.

## Contributing

1. Fork it (<https://github.com/your-github-user/colors/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [dscottboggs](https://github.com/dscottboggs) D. Scott Boggs - creator, maintainer
