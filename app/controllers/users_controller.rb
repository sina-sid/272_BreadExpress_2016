class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  authorize_resource
  
  def show
    @customer = current_user.customer
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
    if current_user.update(updatable_user_params)
      redirect_to user_path(@user), notice: "Successfully updated your user profile."
    else
      render action: 'edit'
    end
  end

  def destroy
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def updatable_user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end

end