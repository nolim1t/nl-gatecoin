# Gatecoin Ruby Client
## Status
This is still under development

## Installing
```bash
gem build nl-gatecoin.gemspec
gem install nl-gatecoin-X.X.X.gem
```

### The Gemfile method
```ruby
source 'https://rubygems.org'

gem 'httparty'
gem 'nl-gatecoin'
```

## Example calls
### Get HKD Balance
```ruby
require './lib/nl-gatecoin'
g = Gatecoin.new
puts g.get_Balance_Balances_HKD
```

### Make a trade
```ruby
require './lib/nl-gatecoin'
g = Gatecoin.new
puts g.post_Trade_Orders(code: "BTCHKD", way: "Bid", amount: "0.01", price: "100")
```
