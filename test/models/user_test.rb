require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_one(:customer)

  should validate_uniqueness_of(:username).case_insensitive
  should allow_value("admin").for(:role)
  should allow_value("baker").for(:role)
  should allow_value("shipper").for(:role)
  should allow_value("customer").for(:role)
  should_not allow_value("bad").for(:role)
  should_not allow_value("hacker").for(:role)
  should_not allow_value(10).for(:role)
  should_not allow_value("vp").for(:role)
  should_not allow_value(nil).for(:role)

  context "Creating a context for users" do
    setup do 
      create_customer_users
    end
    
    teardown do
      destroy_customer_users
    end

    should "show there are 4 active users" do
      assert_equal ["alex", "anthony","melanie", "ryan"], User.active.all.map(&:username).sort
    end

    should "show there is 1 inactive user" do
      assert_equal ["sherry"], User.inactive.all.map(&:username)
    end

    should "show there are 3 employees" do 
      create_employee_users 
      assert_equal ["andy", "dan", "luke"], User.employees.all.map(&:username).sort  
      destroy_employee_users	
    end

    should "order users alphabetically" do
      assert_equal ["alex", "anthony", "melanie", "ryan", "sherry"], User.alphabetical.all.map(&:username)
    end

    should "order users by role" do
      create_employee_users
      assert_equal ["dan", "luke", "alex", "anthony", "melanie", "ryan", "sherry", "andy"], User.by_role.all.map(&:username)
      destroy_employee_users
    end

    should "have working role? method" do 
      create_employee_users
      assert @alexe_user.role?(:customer)
      deny @melanie_user.role?(:baker)
      assert @dan_user.role?(:admin)
      destroy_employee_users
    end

    should "have working class method for authenication" do 
      assert User.authenticate("alex", "secret")
      deny User.authenticate("melanie", "password")
    end

    should "require a password for new users" do
      bad_user = FactoryGirl.build(:user, username: "kathryn", password: nil, password_confirmation: nil, role: "baker")
      deny bad_user.valid?
    end
    
    should "require passwords to be confirmed and matching" do
      bad_user_1 = FactoryGirl.build(:user, username: "kathryn", password: "secret", password_confirmation: nil)
      deny bad_user_1.valid?
      bad_user_2 = FactoryGirl.build(:user, username: "ralph", password: "secret", password_confirmation: "stuff")
      deny bad_user_2.valid?
    end
    
    should "require passwords to be at least four characters" do
      bad_user = FactoryGirl.build(:user, username: "kathryn", password: "meh")
      deny bad_user.valid?
    end

  end
end
