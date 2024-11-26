class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!, only: [ :create, :new ]

  before_action :redirect_if_signed_in, only: [ :create, :new ]

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

  private

  def redirect_if_signed_in
    redirect_to dashboard_path if user_signed_in?
  end
end
