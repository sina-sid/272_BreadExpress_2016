module Contexts
  module Users
    # Context for customers
    def create_users
      @alex_user = FactoryGirl.create(:user, username: "alex", role: "admin")
      @ben_user = FactoryGirl.create(:user, username: "ben", role: "shipper")
      @bryan_user = FactoryGirl.create(:user, username: "bryan", role: "baker", active: false)
      @anthony_user = FactoryGirl.create(:user, username: "anthony", role: "customer")
      @harry_user  = FactoryGirl.create(:user, username: "harry", role: "customer", active: false)
    end
    
    def destroy_users
      @alex_user.delete
      @ben_user.delete
      @anthony_user.delete
      @bryan_user.delete 
      @harry_user.delete
    end

  end
end