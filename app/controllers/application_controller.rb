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

    def get_modal_window(selecter=".modal-container")
      render "shared/get.js", locals: { selecter: selecter, html_template: calling_method }
    end

    def hide_modal_window(submit_object, html_template, rerender_selecter,
                          modal_selecter=".modal-container",
                          **html_args)
      render "shared/hide", locals: { object: submit_object,
                                         rerender_selecter: rerender_selecter,
                                         modal_selecter: modal_selecter,
                                         html_template: html_template,
                                         html_args: html_args}
    end

    private

      def calling_method
        caller[1][/`([^']*)'/, 1]
      end
end
