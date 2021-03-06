class ItemsController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_action :check_login
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  authorize_resource

  # carrierwave to upload photos
  
  def index
    @active_items = Item.active.alphabetical.paginate(:page => params[:page]).per_page(9)
    @active_bread = Item.active.alphabetical.for_category("bread").paginate(:page => params[:page]).per_page(6)
    @active_pastries = Item.active.alphabetical.for_category("pastries").paginate(:page => params[:page]).per_page(6)
    @active_muffins = Item.active.alphabetical.for_category("muffins").paginate(:page => params[:page]).per_page(6)
    if logged_in? && !current_user.role?(:customer)
      @inactive_items = Item.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
    end      
  end

  def show
    @current_price = @item.current_price
    @similar_items = Item.active.alphabetical.for_category(@item.category)
    if logged_in? && !current_user.role?(:customer)
      @price_history = @item.item_prices.chronological.paginate(:page => params[:page]).per_page(5)
      @orders_including_item = @item.order_items.paginate(:page => params[:page]).per_page(5)
    end
  end

  def new
    @item = Item.new
    item_price = @item.item_prices.build

  end

  def edit
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      # create_item_price

      redirect_to @item, notice: "#{@item.name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    if @item.update(item_params)
      redirect_to @item, notice: "#{@item.name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @item.destroy
    redirect_to items_path, notice: "#{@item.name} was removed from the system."
  end

  private
  def set_item
    @item = Item.find(params[:id])
  end

  def create_item_price
    # @item_price = ItemPrice.new
    # @item_price.item_id = @item.id
    # # @item_price.price = params[:item][:price].to_i
    # @item_price.start_date = Date.today
    # @item_price.save!
  end

  def item_params
    params.require(:item).permit(:name, :description, :picture, :photo, :category, :units_per_item, :weight, :active, item_prices_attributes: [:price])
  end
end