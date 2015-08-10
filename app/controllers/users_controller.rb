class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :current_user,   only: [:edit, :update]
  
  def index
    @users = User.all
  end
  
  def show # 追加
   @user = User.find(params[:id])
   @microposts = @user.microposts.page params[:page]
  end
  
  def new
    @user = User.new
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to root_path , notice: 'ユーザー情報を編集しました。'
    else
      render 'edit'
    end
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.order(:name).page params[:page]
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.order(:name).page params[:page]
    render 'show_follow'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :area, :profile, :password_confirmation)
  end
end
