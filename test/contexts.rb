# require needed files
require './test/sets/orders'
require './test/sets/customers'
require './test/sets/addresses'
require './test/sets/users'
require './test/sets/credit_cards'
require './test/sets/items'
require './test/sets/item_prices'
require './test/sets/order_items'

module Contexts
  # explicitly include all sets of contexts used for testing 
  include Contexts::Orders
  include Contexts::Customers
  include Contexts::Addresses
  include Contexts::Users
  include Contexts::CreditCards
  include Contexts::Items
  include Contexts::ItemPrices
  include Contexts::OrderItems
end