class CartController < ApplicationController
  include BreadExpressHelpers::Cart

  def index
  	@cart_order_items = get_list_of_items_in_cart
  end

  def show
  	@cart_order_items = get_list_of_items_in_cart
  end

  def add_to_cart
  	add_item_to_cart(@item_id)
  end

end