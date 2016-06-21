class Ability
  include CanCan::Ability
  
  def initialize(user)
    # set user to new User if not logged in
    user ||= User.new # i.e., a guest user

    #######################
    ## ADMINS
    #######################
    if user.role? :admin
      # they get to do it all
      can :manage, :all
    
    #######################
    ## SHIPPERS	
    #######################  
    elsif user.role? :shipper

      # USER
      # can see their own user info
      can :show, User do |u|  
        u.id == user.id
      end

      # can update their own user info
      can :update, User do |u|  
        u.id == user.id
      end  

      # ORDERITEM
      # can see, update orderitems
      can :manage, OrderItem

      # ITEM, ITEMPRICE, ORDER, ADDRESS, CUSTOMER
      # can see all
      can :read, Item
      can :read, ItemPrice
      can :read, Order
      can :read, Address
      can :read, Customer

    #######################
    ## BAKERS
    #######################  
    elsif user.role? :baker
 
      # USER
      # can see their own user info
      can :show, User do |u|  
        u.id == user.id
      end

      # can update their own user info
      can :update, User do |u|  
        u.id == user.id
      end 

      # ITEM, ITEMPRICE, ORDERITEM
      # can see all items
      can :read, Item
      can :read, ItemPrice
      can :read, OrderItem
      can :read, Order
      can :read, Address
      can :read, Customer

    #######################
    ## CUSTOMERS
    #######################  
    elsif user.role? :customer

      # USER
      # can see their own user info
      can :show, User do |u|  
        u.id == user.id
      end

      # can update their own user info
      can :update, User do |u|  
        u.id == user.id
      end 

      # CUSTOMERS
      # can see their own info
      can :show, Customer do |c|  
        c.id == user.customer.id
      end

      # can update their own user info
      can :update, Customer do |c|  
        c.id == user.customer.id
      end 

      # ORDER 
      can :manage, Order do |o|
        o.order.customer_id == user.customer.id
      end

      # can create orders for themselves
      # can :create, Order do |o|
      #   o.customer_id == user.customer.id
      # end

      # # can see their past orders
      # can :read, Order do |o|
      # 	o.customer_id == user.customer.id
      # end

      # # can update orders with no shipped items?
      # can :update, Order do |o|
      # 	if o.order_items.shipped.empty?
      # 	  o.customer_id == user.customer_id
      # 	end
      # end

      # can :manage orders, orderitems

      # ORDER ITEM
      can :manage, OrderItem do |oi|
        oi.order.customer_id == user.customer.id
      end

      # can see order_items in order placed by them
      # can :read, OrderItem do |oi|
      # 	oi.order.customer_id == user.customer.id
      # end

      # # can create order_items for themselves
      # can :create, OrderItem do |oi|
      # 	oi.order.customer_id == user.customer.id
      # end

      # # can update order_items if unshipped
      # can :update, OrderItem do |oi|
      # 	if oi.shipped_on.nil?
      # 	  oi.order.customer_id == user.customer.id
      # 	end
      # end

      # # can destroy order_items if unshipped
      # can :update, OrderItem do |oi|
      # 	if oi.shipped_on.nil?
      # 	  oi.order.customer_id == user.customer.id
      # 	end
      # end

      # ITEM, ITEMPRICE
      # Can see active items
      can :read, Item do |i|
        i.active
      end

      # Can see active itemprices      
      can :read, ItemPrices do |ip|
        ip.end_date.nil?
      end

      # ADDRESS
      # can create addresses for themselves
      can :create, Address do |a|
      	a.customer_id == user.customer_id
      end

      # can update addresses for themselves
      can :update, Address do |a|
      	a.customer_id == user.customer_id
      end

      # can see their addresses
      can :read, Address do |a|
      	a.customer_id == user.customer_id
      end

      # can destroy their addresses
      can :destroy, Address do |a|
      	a.customer_id == user.customer_id
      end


    #######################
    ## GUESTS
    #######################  
    else
      # Can see current items, current item_prices
      can :read, Item
      can :read, ItemPrices

      can :create, Customer
      can :create, User
    end
  end
end