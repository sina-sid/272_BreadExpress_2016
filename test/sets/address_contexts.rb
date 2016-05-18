module Contexts
  module AddressContexts

  	def create_addresses
  	  @abc_address = FactoryGirl.create(:address, customer: @abc)
      @cindy_nb_address = FactoryGirl.create(:adress, customer: @cindy, is_billing: false)
      @cindy_inactive_address = FactoryGirl.create(:adress, customer: @cindy, active: false)
      @bob_address = FactoryGirl.create(:address, customer: @bob)
      @rob_address = FactoryGirl.create(:address, customer: @rob)
      # cannot create add for inactive
      # change bob, rob to inactive later
      # @rob = FactoryGirl.create(:customer, first_name: "Rob", last_name: "Bery", email: "robbery@example.com", active: false)
  	end

  	def remove_addresses
  	  @abc_address.delete
      @cindy_nb_address
      @cindy_inactive_address
      @bob_address.delete
      @rob_address.delete
  	end

  end
end