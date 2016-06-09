module Contexts
  module Users
    # Context for users
    def create_customer_users
      @alexe_user = FactoryGirl.create(:user, username: "alex", role: "customer")
      @melanie_user = FactoryGirl.create(:user, username: "melanie", role: "customer")
      @ryan_user = FactoryGirl.create(:user, username: "ryan", role: "customer")
      @anthony_user = FactoryGirl.create(:user, username: "anthony", role: "customer")
      @sherry_user  = FactoryGirl.create(:user, username: "sherry", role: "customer", active: false)
    end
    
    def destroy_customer_users
      @alexe_user.delete
      @melanie_user.delete
      @anthony_user.delete
      @ryan_user.delete 
      @sherry_user.delete
    end

    def create_employee_users
      @dan_user = FactoryGirl.create(:user, username: "dan", role: "admin")
      @andy_user = FactoryGirl.create(:user, username: "andy", role: "shipper")
      @luke_user = FactoryGirl.create(:user, username: "luke", role: "baker")
    end

    def destroy_employee_users
      @dan_user.delete
      @andy_user.delete
      @luke_user.delete
    end

  end
end