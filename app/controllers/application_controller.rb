class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

    def logged_in_user(redirect_target=nil)
      unless logged_in?
        store_location(redirect_target)
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def current_user?(user)
      user == current_user
    end

    def correct_user(user_id=params[:id])
      @user = User.find(user_id)
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
