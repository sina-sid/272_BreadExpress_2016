class HomeController < ApplicationController
  include BreadExpressHelpers::Baking

  def home
  	if logged_in? && current_user.role?(:admin)
      @total_revenue = calculate_total_revenue
      @newest_items = Item.order(created_at: :desc).limit(4)
      @num_unpaid_orders = Order.where(payment_receipt: nil).count
      @num_unshipped_items = OrderItem.unshipped.count
      @num_unshipped_orders = Order.not_shipped.count
      @num_active_customers = Customer.active.count
      @num_orders_in_last_month = Order.where('created_at >= ?', 1.month.ago.to_datetime).count
  	  # how many of each item is being ordered (popularity)
  	  # recently updated prices?
  	elsif logged_in? && current_user.role?(:baker)
  	  baking_lists
  	elsif logged_in? && current_user.role?(:shipper)
  	  baking_lists
  	  @unshipped_orders = Order.not_shipped.chronological.paginate(:page => params[:page]).per_page(5)
  	elsif logged_in? && current_user.role?(:customer)
  	  @newest_items = Item.order(:created_at).limit(4)
    else
      @newest_items = Item.order(:created_at).limit(4)
  	end	
  end

  def about
  end

  def privacy
  end

  def contact
  end

  def remove_from_baking_list(list, name)
    list.delete(name)
  end

  private
  def calculate_total_revenue
    total = 0
    Order.paid.each do |order|
      total+= order.grand_total
    end
    total
  end

  def baking_lists
  	@bread_list = create_baking_list_for("bread")
  	@pastries_list = create_baking_list_for("pastries")
  	@muffins_list = create_baking_list_for("muffins")
  end
end