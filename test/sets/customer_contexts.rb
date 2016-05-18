module Contexts
  module CustomerContexts

  	def create_customers
  	  @abc = FactoryGirl.create(:customer)
      @cindy = FactoryGirl.create(:customer, first_name: "Cindy", last_name: "Crawford", email: "cindy_c@example.com", phone: "412-123-4567")
      @bob = FactoryGirl.create(:customer, first_name: "Bob", last_name: "By", email: "bobby@example.com", active: false)
      @rob = FactoryGirl.create(:customer, first_name: "Rob", last_name: "Bery", email: "robbery@example.com", active: false)
  	end

  	def remove_customers
  	  @abc.delete
      @cindy.delete
      @bob.delete
      @rob.delete
  	end

  end
end