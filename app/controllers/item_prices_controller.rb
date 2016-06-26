class ItemPricesController < ApplicationController
  # include ActionView::Helpers::NumberHelper
  # before_action :check_login
  before_action :set_item_price, only: [:edit, :update, :destroy]
  authorize_resource
  
  def index
    @active_item_prices = ItemPrice.current.chronological.paginate(:page => params[:page]).per_page(10)
    if logged_in? && !current_user.role?(:customer)
      @inactive_item_prices = ItemPrice.where.not(end_date: nil).chronological.paginate(:page => params[:page]).per_page(10)
    end
  end

  def show
  end

  def new
    @item_price = ItemPrice.new

  end

  def edit
  end

  def create
    @item_price = ItemPrice.new(item_price_params)
    @item_price.start_date = Date.today
    if @item_price.save
      redirect_to @item_price.item, notice: "A new price for #{@item_price.item.name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    if @item_price.update(item_price_params)
      redirect_to @item_price, notice: "#{@item_price.item.name}'s price was revised in the system."
    else
      render action: 'edit'
    end
  end

  private
  def set_item_price
    @item_price = ItemPrice.find(params[:id])
  end

  def item_price_params
    params.require(:item_price).permit(:item_id, :price, :start_date, :end_date)
  end
end