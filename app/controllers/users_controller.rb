class UsersController < ApplicationController
  before_action :logged_in_user, except: [:show, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :find_user, only: [:show, :edit, :update]

  def index
    @users = User.paginate(page: params[:page]).order "id ASC"
  end

  def show
    @microposts = @user.microposts.paginate(page: params[:page], per_page: 5)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "user_mailer.account_activation.activation_confirm"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "flash.update_profile"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    User.find_by!(id: params[:id]).destroy
    flash[:success] = t "flash.delete_user"
    redirect_to users_url
  end

  def find_user
    @user = User.find_by! id: params[:id]
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

end
