# TO DO: DOES SHOW METHOD UPDATE WITH EVERY ADDITION TO CART?

class OrdersController < ApplicationController
  include BreadExpressHelpers::Cart
  include BreadExpressHelpers::Shipping
  before_action :check_login
  before_action :set_order, only: [:show, :update, :destroy]
  authorize_resource
  
  def index
    if logged_in? && !current_user.role?(:customer)
      @pending_orders = Order.not_shipped.chronological.paginate(:page => params[:page]).per_page(5)
      @all_orders = Order.chronological.paginate(:page => params[:page]).per_page(5)
    else
      @pending_orders = current_user.customer.orders.not_shipped.chronological.paginate(:page => params[:page]).per_page(5)
      @all_orders = current_user.customer.orders.chronological.paginate(:page => params[:page]).per_page(5)
    end 
  end

  def create_empty_cart
    if logged_in? && current_user.role?(:customer)
      create_cart
    end
  end

  def add_item_to_cart
  end

  def remove_from_cart
  end

  def view_cart
    @cart_items = get_list_of_items_in_cart.paginate(:page => params[:page]).per_page(10)
    @total_cost = calculate_cart_items_cost
    @shipping_costs = calculate_cart_shipping
  end

  def checkout
    if logged_in? && current_user.role?(:customer)
      save_each_item_in_cart(@order)
      clear_cart
    end
  end

  def show
    @order_items = @order.order_items.to_a
    if logged_in? && current_user.role?(:customer)
      view_cart
      @previous_orders = current_user.customer.orders.chronological.to_a
    elsif logged_in?
      @previous_orders = @order.customer.orders.chronological.to_a
    end
  end

  def new
  end

  def create
    @order = Order.new(order_params)
    create_empty_cart
    if @order.save
      checkout
      redirect_to @order, notice: "Thank you for ordering from Bread Express."
    else
      render action: 'new'
    end
  end

  def update
    # to do, find ways to figure out what update has been made to the cart and call fns accordingly
    if @order.update(order_params)
      redirect_to @order, notice: "Your order was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    if logged_in? && current_user.role?(:customer)
      destroy_cart #or clear_cart?
    end
    @order.destroy
    redirect_to orders_url, notice: "This order was removed from the system."
  end

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:address_id)
  end
end