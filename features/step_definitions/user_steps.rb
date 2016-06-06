require './test/contexts'
include Contexts

Given /^an initial setup$/ do
  # context used for phase 3 only
  create_customers
  create_addresses
  create_orders
end

Given /^no setup yet$/ do
  # assumes initial setup already run as background
  destroy_orders
  destroy_addresses
  destroy_customers
end
