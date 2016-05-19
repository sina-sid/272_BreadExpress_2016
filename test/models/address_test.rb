require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  # Test relationships
  should belong_to(:customer)
  should have_many(:orders)

  # Testing Validations
  should validate_presence_of(:recipient)
  should validate_presence_of(:street_1)
  should validate_presence_of(:zip)

  # Tests for zip
  should allow_value("15213").for(:zip)
  should_not allow_value("bad").for(:zip)
  should_not allow_value("1512").for(:zip)
  should_not allow_value("152134").for(:zip)
  should_not allow_value("15213-0983").for(:zip)

  # Tests for state
  should allow_value("OH").for(:state)
  should allow_value("PA").for(:state)
  should allow_value("WV").for(:state)
  should allow_value("NY").for(:state)
  should_not allow_value("bad").for(:state)  
  should_not allow_value(10).for(:state)

  context "Creating a context for addresses" do
    setup do
      create_customers
      create_addresses
    end
    teardown do
      remove_customers
      remove_addresses
    end

    should "not allow duplocate addresses to be created" do
      @bad_address = FactoryGirl.build(:address, customer: @abc, street_1: "2461 Ave Ave")
      deny @bad_address.valid?
    end

    should "only allow addresses to be made for active customers" do
      @abc_new = FactoryGirl.build(:address, customer: @abc, recipient: "Abc Def", street_1: "4614 Fifth Avenue", zip: "15213")
      assert @abc_new.valid?
      @bad_customer_address = FactoryGirl.build(:address, customer: @bob, street_1: "12345 Avenue", zip:"12312")
      deny @bad_customer_address.valid?
    end

    should "show there are two active addresses" do
      # assert_equal 2, Customer.active.size
      # assert_equal ["Crawford", "Def"], Customer.active.map{|e| e.last_name}.sort
    end

    should "show there are two inactive addresses" do
      # assert_equal 2, Customer.active.size
      # assert_equal ["Crawford", "Def"], Customer.active.map{|e| e.last_name}.sort
    end

    should "order addresses by recipient name" do
      assert_equal ["Bob", "Cindy", "Dad", "Home", "My Mom"], Address.by_recipient.map{|a| a.recipient}
    end

    should "order addresses by customer name" do
      assert_equal ["Bery", "By", "Crawford", "Crawford", "Def"], Address.by_customer.map{|a| a.by_customer}
    end

    should "show that there are x shipping addresses" do
    end

    should "show that there are x billing addresses" do
    end
  end
end
