module Contexts
  module AddressContexts

  	def create_addresses
  	  @abc_address = FactoryGirl.create(:address, customer: @abc)
      @cindy_address = FactoryGirl.create(:address, customer: @cindy, recipient: "Dad", street_1: "5000 Fifth Avenue")
      @cindy_nb_address = FactoryGirl.create(:address, customer: @cindy, recipient: "Cindy", is_billing: false, street_1: "2000 Forbes Avenue", zip:"15203")
      @bob.active = true
      @bob.save!
      @bob_address = FactoryGirl.create(:address, customer: @bob, recipient: "Bob", street_1: "5000 Not CMU", zip:"12345", active: false)
      @bob.active = false
      @bob.save!
      @rob.active = true
      @rob.save!
      @rob_address = FactoryGirl.create(:address, recipient: "Home", customer: @rob, street_1: "12345 Ave", active: false)
      @rob.active = false
      @rob.save!
  	end

  	def remove_addresses
  	  @abc_address.delete
      @cindy_nb_address
      @cindy_address
      @bob_address.delete
      @rob_address.delete
  	end

  end
end