class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit]

  def index
    @all_orders = Order.chronological.paginate(page: params[:page]).per_page(10)
  end

  def show
    @customer_orders = Order.for_customer(@order.customer_id).paginate(page: params[:page]).per_page(10)
    @year_joined = @order.customer.created_at.year
  end

  def new
  	@order = Order.new
  end

  def edit
  end

  def create
  	@order = Order.new(order_params)
    
    if @order.save
      redirect_to order_path(@order), notice: "Thank you for ordering from Bread Express"
    else
      render action: 'new'
    end
  end

  def update
  	if @order.update(order_params)
      redirect_to order_path(@order), notice: "was revised in the system."
    else
      render action: 'edit'
    end
  end

  # def destroy
  # 	order.destroy
  #   redirect_to orders_path, notice: "was removed from the system."
  # end

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:customer_id, :address_id, :date, :grand_total, :payment_receipt)
  end
end
