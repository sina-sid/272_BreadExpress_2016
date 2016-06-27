class OrdersController < ApplicationController
  include BreadExpressHelpers::Cart
  include BreadExpressHelpers::Shipping
  before_action :check_login
  before_action :set_order, only: [:show, :update, :destroy]
  authorize_resource

  # CART METHODS

  def view_cart
    @cart_order_items = get_list_of_items_in_cart
    @shipping_costs = calculate_cart_shipping
    @subtotal = calculate_cart_items_cost
    @grand_total = @shipping_costs + @subtotal
  end

  def add_to_cart
    add_item_to_cart(params[:id])
    redirect_to cart_url, notice: "Added to cart!"
  end

  def remove_from_cart
    remove_item_from_cart(params[:id])
    redirect_to cart_url, notice: "Removed from cart!"
  end


  def checkout
    if logged_in? && current_user.role?(:customer)
      save_each_item_in_cart(@order)
      clear_cart
    end
  end

  # REGULAR ORDER METHODS

  def index
    if logged_in? && !current_user.role?(:customer)
      @pending_orders = Order.not_shipped.chronological.paginate(:page => params[:page]).per_page(5)
      @all_orders = Order.chronological.paginate(:page => params[:page]).per_page(5)
    else
      @pending_orders = current_user.customer.orders.not_shipped.chronological.paginate(:page => params[:page]).per_page(5)
      @all_orders = current_user.customer.orders.chronological.paginate(:page => params[:page]).per_page(5)
    end 
  end

  def show
    @order_items = @order.order_items.to_a
    if logged_in? && current_user.role?(:customer)
      @previous_orders = current_user.customer.orders.chronological.to_a
    elsif logged_in?
      @previous_orders = @order.customer.orders.chronological.to_a
    end
  end

  def new
    create_cart if logged_in? && current_user.role?(:customer)
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    create_cart if logged_in? && current_user.role?(:customer)
    if @order.save
      checkout
      redirect_to @order, notice: "Thank you for ordering from Bread Express."
    else
      render action: 'new'
    end
  end

  def update
    # is_editable?
    if @order.update(order_params)
      redirect_to @order, notice: "Your order was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    clear_cart if logged_in? && current_user.role?(:customer)
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