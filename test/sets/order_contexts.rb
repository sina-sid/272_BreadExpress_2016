module Contexts
  module OrderContexts

  	def create_orders
  	  @abc_order1 = FactoryGirl.create(:order, customer: @abc, address: @abc_address)
  	  @abc_order2 = FactoryGirl.create(:order, customer: @abc, address: @abc_address, grand_total: 22.5)
  	  @cindy_order1 = FactoryGirl.create(:order, customer: @cindy, address: @cindy_address)
  	  # @cindy_order2 = FactoryGirl.create(:order, customer: @cindy, address: @cindy_inactive_address)
  	  @bob.active = true
      @bob.save!
  	  @bob_order1 = FactoryGirl.create(:order, customer: @bob, address: @bob_address)
  	  @bob.active = false
      @bob.save!
  	end

  	def remove_orders
  	  @abc_order1.delete
  	  @abc_order2.delete
  	  @cindy_order1.delete
  	  # @cindy_order2.delete
  	  @bob_order1.delete
  	end

  end
end