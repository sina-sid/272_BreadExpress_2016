require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  # test relationships
  should belong_to(:customer)
  should have_many(:orders)

  # test validations with matchers
  should validate_presence_of(:recipient)
  should validate_presence_of(:street_1)
  should validate_inclusion_of(:state).in_array(Address::STATES_LIST.to_h.values)

  should allow_value("12345").for(:zip)
  should_not allow_value("1234").for(:zip)
  should_not allow_value("123456").for(:zip)
  should_not allow_value("12345-0001").for(:zip)
  should_not allow_value("1234I").for(:zip)
  should_not allow_value(nil).for(:zip)

  context "Within context" do
    setup do 
      create_customers
      create_addresses
    end
    
    teardown do
      destroy_customers
      destroy_addresses
    end

    should "show that by_recipient places addresses in alphabetical order" do
      assert_equal ["Alex Egan", "Anthony Corletti", "Jeff Egan", "Melanie Freeman", "Ryan Flood", "Zach Egan"], Address.by_recipient.all.map(&:recipient)
    end

    should "show that by_customer places addresses in alphabetical order by customer" do
      assert_equal ["Anthony Corletti", "Alex Egan", "Jeff Egan", "Zach Egan", "Ryan Flood", "Melanie Freeman"], Address.by_customer.by_recipient.all.map(&:recipient)
    end

    should "show that there are two active addresses and one inactive address" do
      assert_equal 5, Address.active.all.count
      assert_equal ["Zach Egan"], Address.inactive.all.map(&:recipient).sort
    end

    should "show that scopes for billing and shipping" do
      assert_equal ["Alex Egan", "Anthony Corletti", "Melanie Freeman", "Ryan Flood"], Address.billing.all.map(&:recipient).sort
      assert_equal ["Jeff Egan", "Zach Egan"], Address.shipping.all.map(&:recipient).sort
    end

    should "verify that the customer is active in the system" do
      # test the inactive customer first
      bad_address = FactoryGirl.build(:address, customer: @sherry, recipient: "Sherry Chen", is_billing: true, active: true)
      deny bad_address.valid?
      # test the nonexistent customer
      ghost = FactoryGirl.build(:customer, first_name: "Ghost")
      non_customer_address = FactoryGirl.build(:address, customer: ghost)
      deny non_customer_address.valid?
    end 

    should "verify customer's address for this recipient is not already in the system" do
      bad_address = FactoryGirl.build(:address, customer: @alexe, recipient: "Jeff Egan", is_billing: false, zip: "15212")
      deny bad_address.valid?
    end 

    should "allow an address 'duplication' if it belongs to a different customer" do
      # same address as before, but belongs now to Melanie instead of Alex
      good_address = FactoryGirl.build(:address, customer: @melanie, recipient: "Jeff Egan", is_billing: false, zip: "15212")
      assert good_address.valid?
    end

    should "allow an existing address to be edited" do
      @alexe_a1.street_1 = "5005 Forbes Avenue"
      assert @alexe_a1.valid?
    end

    should "set appropriate addresses to inactive once destroyed" do
      create_orders
      @alexe_a2.destroy
      assert @alexe_a2.valid?
      deny @alexe_a2.active
      destroy_orders
    end
    
  end
end

