class OrderItemsController < ApplicationController
  # include ActionView::Helpers::NumberHelper
  before_action :check_login
  before_action :set_order_item, only: [:edit, :update, :destroy]
  authorize_resource
  
  def index
    if logged_in? && !current_user.role?(:customer)
      @shipped_order_items = OrderItem.shipped.paginate(:page => params[:page]).per_page(10)
      @unshipped_order_items = OrderItem.unshipped.paginate(:page => params[:page]).per_page(10)
    elsif logged_in? && current_user.role?(:customer)
      @shipped_order_items = OrderItem.shipped.joins(:orders).where("customer_id = ?", current_user.customer.id).paginate(:page => params[:page]).per_page(10)
      @unshipped_order_items = OrderItem.unshipped.joins(:orders).where("customer_id = ?", current_user.customer.id).paginate(:page => params[:page]).per_page(10)
    end
  end

  def show
  end

  def new
    @order_item = OrderItem.new

  end

  def edit
  end

  def create
    @order_item = OrderItem.new(order_item_params)
    if @order_item.save
      redirect_to @order_item, notice: "#{@order_item.item.name} was added to this order."
    else
      render action: 'new'
    end
  end

  def update
    if @order_item.update(order_item_params)
      redirect_to @order_item, notice: "#{@order_item.item.name} was revised for this order."
    else
      render action: 'edit'
    end
  end

  def destroy
    @order_item.destroy
    redirect_to addresss_url, notice: "#{order_item.item.name} was removed from this order."
  end

  private
  def set_order_item
    @order_item = OrderItem.find(params[:id])
  end

  def order_item_params
    params.require(:order_item).permit(:item_id, :price, :start_date, :end_date)
  end
end