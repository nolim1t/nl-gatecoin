# Gatecoin Ruby Client
[![Gem Version](https://badge.fury.io/rb/nl-gatecoin.svg)](https://badge.fury.io/rb/nl-gatecoin)

## Status
This is still under development and not an official library of Gatecoin. Use at your own risk!

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
require 'nl-gatecoin'
g = Gatecoin.new
puts g.get_Balance_Balances_HKD
```

### Make a trade
```ruby
require 'nl-gatecoin'
g = Gatecoin.new
puts g.post_Trade_Orders(code: "BTCHKD", way: "Bid", amount: "0.01", price: "100")
```
### Get Orderbook

```ruby
require 'nl-gatecoin'
g = Gatecoin.new
puts g.pubget_MarketDepth_BTCHKD
```
