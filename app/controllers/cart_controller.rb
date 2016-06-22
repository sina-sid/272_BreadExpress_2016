class CartController < ApplicationController
  include BreadExpressHelpers::Cart

  def index
  end

  def show
  	@cart_order_items = get_list_of_items_in_cart
  end

  def find_order_items_in_system
  	cart_order_items = Array.new
  	cart_arr = get_list_of_items_in_cart
  	cart_arr.each do |oi|
  	  order_item = OrderItem.find(oi.id)
  	  cart_order_items << order_item unless order_item.nil?
  	end
  	cart_order_items
  end

  def add_to_cart
  	add_item_to_cart(params[:id])
  	redirect_to cart_url
  end

end