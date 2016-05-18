require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  # Test relationships
  should have_many(:addresses)
  should have_many(:orders)
  
  # Test basic validations
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)
  should validate_presence_of(:email)
  should validate_presence_of(:phone)

  # tests for phone
  should allow_value("4122683259").for(:phone)
  should allow_value("412-268-3259").for(:phone)
  should allow_value("412.268.3259").for(:phone)
  should allow_value("(412) 268-3259").for(:phone)
  should allow_value(nil).for(:phone)
  should_not allow_value("2683259").for(:phone)
  should_not allow_value("14122683259").for(:phone)
  should_not allow_value("4122683259x224").for(:phone)
  should_not allow_value("800-EAT-FOOD").for(:phone)
  should_not allow_value("412/268/3259").for(:phone)
  should_not allow_value("412-2683-259").for(:phone)

  # tests for email
  should allow_value("fred@fred.com").for(:email)
  should allow_value("fred@andrew.cmu.edu").for(:email)
  should allow_value("my_fred@fred.org").for(:email)
  should allow_value("fred123@fred.gov").for(:email)
  should allow_value("my.fred@fred.net").for(:email)

  should_not allow_value("fred").for(:email)
  should_not allow_value("fred@fred,com").for(:email)
  should_not allow_value("fred@fred.uk").for(:email)
  should_not allow_value("my fred@fred.com").for(:email)
  should_not allow_value("fred@fred.con").for(:email)

  context "Creating a context for customers" do
    setup do 
      # create_customers
      @abc = FactoryGirl.create(:customer)
      @cindy = FactoryGirl.create(:customer, first_name: "Cindy", last_name: "Crawford", email: "cindy_c@example.com", phone: "412-123-4567")
      @bob = FactoryGirl.create(:customer, first_name: "Bob", last_name: "By", email: "bobby@example.com", active: false)
      @rob = FactoryGirl.create(:customer, first_name: "Rob", last_name: "Bery", email: "robbery@example.com", active: false)
    end
    teardown do
      # remove_customers
      @abc.delete
      @cindy.delete
      @bob.delete
      @rob.delete
    end

    should "show there are two active customers" do
      assert_equal 2, Customer.active.size
      assert_equal ["Crawford", "Def"], Customer.active.map{|e| e.last_name}.sort
    end

    should "show there are two inactive customers" do
      assert_equal 2, Customer.inactive.size
      assert_equal ["Bery", "By"], Customer.inactive.map{|e| e.last_name}.sort
    end

    should "display the customer names alphabetically" do
      assert_equal ["Bery", "By", "Crawford", "Def"], Customer.alphabetical.map{|e| e.last_name}
    end

    should "display the customer's name in last name, first name format" do
      assert_equal "Crawford, Cindy", @cindy.name
    end

    should "display the customer's name in first name last name format" do
      assert_equal "Cindy Crawford", @cindy.proper_name
    end
end
