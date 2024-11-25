class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    auth = request.env["omniauth.auth"]
    user = Users::FindViaSteam.call(auth)

    sign_in_and_redirect user, event: :authentication
  end

  def destroy
    sign_out_and_redirect(current_user)
    flash[:notice] = "You have been logged out successfully."
  end

  def new
  end
end
