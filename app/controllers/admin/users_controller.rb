class Admin::UsersController < ApplicationController
  before_filter :restrict_admin

  def switch_to_user
    @current_user = User.find(params[:id])
    session[:user_id] = @current_user.id
  end

  def switch_to_admin
    
  end
 
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, notice: "#{@user.full_name} was created succesfully"
    else
      render :'admin/users/new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(user_params)
    if @user.save
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy    

    if @user.destroy
      # Tell the UserMailer to send delete email after destroy
      UserMailer.delete_confirmation(@user).deliver
      redirect_to admin_users_path, notice: "#{@user.full_name} was deleted succesfully"
      flash[:success] = 'Deleted successfully.'

    else
      render :new
    end

  end

  protected

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :admin, :password, :password_confirmation)
  end


end
