class UsersController < ApplicationController
  # only index, edit, update, destroy are affected so that the user must be logged in
  before_action :logged_in_user , only: [:index, :edit, :update, :destroy,
                                         :following, :followers]
  before_action :correct_user,    only: [:edit, :update]
  # restrict destroy actions only to admins
  before_action :admin_user,      only: :destroy


  def index
    # show only users which are activated
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params) # Not the final implementation!
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    # To verify that these attributes aren't editable through the web
    #
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Before filters

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms an admin user, so if its not an admin the destroy action cant
    # be invoked by non admin users
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
