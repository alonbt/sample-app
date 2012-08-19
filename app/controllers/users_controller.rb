class UsersController < ApplicationController
  
  before_filter :signed_in_user, only: [:edit, :update, :index, :destroy]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  before_filter :redirect_signed_in, only: [:new, :create]
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def edit
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def destroy
    user_to_destroy = User.find(params[:id])
    if (user_to_destroy != current_user)
      user_to_destroy.destroy
      flash[:success] = "User destroyed"
    else
      flash[:error] = "You can't delete your own user!"
    end
    redirect_to users_path
  end
  
  def update
    if (@user.update_attributes(params[:user]))
      flash[:success] = "Profile Updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome #{@user.name} to the sample App"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  private
  
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."     
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end
    
    def admin_user
      redirect_to root_path unless current_user.admin?
    end
    
    def redirect_signed_in
        redirect_to root_path if signed_in?
    end
end
