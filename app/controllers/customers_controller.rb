class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update]

  def index
  	@active_customers = Customer.active.alphabetical.paginate(page: params[:page]).per_page(10)
  	@inactive_customers = Customer.inactive.alphabetical.paginate(page: params[:page]).per_page(10)
  end

  def show
  	# show all orders placed by customer
  	@customer_orders = @customer.orders.chronological.paginate(page: params[:page]).per_page(5)
    @year_joined = @customer.created_at.year
  end

  def new
  	@customer = Customer.new
  end

  def edit
  end

  def create
  	@customer = Customer.new(customer_params)
    
    if @customer.save
      redirect_to customer_path(@customer), notice: "#{@customer.proper_name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
  	if @customer.update(customer_params)
      redirect_to customer_path(@customer), notice: "#{@customer.proper_name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  # def destroy
  # 	customer.destroy
  #   redirect_to customers_path, notice: "#{@customer.proper_name} was removed from the system."
  # end

  private
  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :phone, :active)
  end

end
