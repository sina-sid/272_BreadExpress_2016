require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_one(:customer)

  should validate_uniqueness_of(:username).case_insensitive

  context "Creating a context for users" do
    setup do 
      create_users
    end
    
    teardown do
      destroy_users
    end

    should "show there are 3 active users" do
      assert_equal ["alex", "anthony","ben"], User.active.all.map(&:username).sort
    end

    should "show there are 2 inactive users" do
      assert_equal ["bryan", "harry"], User.inactive.all.map(&:username).sort
    end

    should "show there are 3 employees" do  
      assert_equal ["alex", "ben", "bryan"], User.employees.all.map(&:username).sort  	
    end

    should "order users alphabetically" do
      assert_equal ["alex", "anthony","ben", "bryan", "harry"], User.alphabetical.all.map(&:username)
    end

    should "order users by role" do
      assert_equal ["alex", "bryan", "anthony", "harry", "ben"], User.by_role.all.map(&:username)
    end

    should "have working role? method" do 
      assert @alex_user.role?(:admin)
      deny @ben_user.role?(:baker)
      assert @ben_user.role?(:shipper)
    end

    should "have working class method for authenication" do 
      assert User.authenticate("alex", "secret")
      deny User.authenticate("ben", "password")
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
