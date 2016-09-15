class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

    # Confirms a logged_in user.
    # put it here cause I needed in more than once controllers (e.g. user and micropost)
    # so its also available in both controllers
    # unless: Executes code if conditional is false
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
