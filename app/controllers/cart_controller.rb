class CartController < ApplicationController
  include BreadExpressHelpers::Cart
  include BreadExpressHelpers::Shipping

  def index
  end

  def show
  	@cart_order_items = get_list_of_items_in_cart
    @shipping_costs = calculate_cart_shipping
    @subtotal = calculate_cart_items_cost
    @grand_total = @shipping_costs + @subtotal
  end

  def add_to_cart
  	add_item_to_cart(params[:id])
  	redirect_to cart_url
  end

  def remove_from_cart
  	remove_item_from_cart(params[:id])
  	redirect_to cart_url
  end

end