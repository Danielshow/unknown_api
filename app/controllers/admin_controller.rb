# frozen_string_literal: true

# Admin Controller
class AdminController < ActionController::Base
  def index
    if !@current_admin && session[:user] != 'login'
      render :login
      return
    end
    @user = Profile.includes(:user)
    respond_to do |format|
      format.html { render :index }
    end
  end

  def login
    @user = User.new
  end

  def create
    user = User.where(email: params[:email]).first
    is_valid = user&.valid_password?(params[:password])
    return redirect_to admin_login_path if user&.role != 'admin' && !is_valid
    current_admin(user)
    redirect_to admin_users_path
  end

  def logout
    session[:user] = nil
    @current_admin = nil
    redirect_to admin_login_path
  end

  def current_admin(user)
    @current_admin ||= user
    session[:user] = 'login'
  end
end
