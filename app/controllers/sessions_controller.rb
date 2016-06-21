class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_username(params[:username])
    if user && User.authenticate(params[:username], params[:password])
      session[:user_id] = user.id
      create_cart
      redirect_to home_path, notice: "Logged in!"
    else
      flash.now.alert = "Username or password is invalid"
      render "new"
    end
  end

  def destroy
    destroy_cart
    session[:user_id] = nil
    redirect_to home_path, notice: "Logged out!"
  end
end 