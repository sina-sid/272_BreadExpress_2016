class HomeController < ApplicationController
  include BreadExpressHelpers::Baking

  def home
  	if logged_in? && current_user.role?(:admin)
  	  # total revenue
  	  # how many of each item is being ordered (popularity)
  	  # recently updated prices?
  	  # num orders unpaid
  	  # num items unshipped
  	  # num active users
  	elsif logged_in? && current_user.role?(:baker)
  	  baking_lists
  	elsif logged_in? && current_user.role?(:shipper)
  	  baking_lists
  	  @unshipped_orders = Order.not_shipped.chronological.paginate(:page => params[:page]).per_page(5)
  	else
  	  create_cart
  	  # recommendations/updated items?
  	  # newly added items
  	end	
  end

  def about
  end

  def privacy
  end

  def contact
  end

  private
  def baking_lists
  	@bread_list = create_baking_list_for("bread")
  	@pastries_list = create_baking_list_for("pastries")
  	@muffins_list = create_baking_list_for("muffins")
  end
end