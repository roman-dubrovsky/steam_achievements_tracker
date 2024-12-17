# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!, only: %i[create new]

  before_action :redirect_if_signed_in, only: %i[create new]

  def new
  end

  def create
    auth = request.env["omniauth.auth"]
    user = Users::FindViaSteam.call(auth)

    sign_in_and_redirect user, event: :authentication
  end

  def destroy
    sign_out_and_redirect(current_user)
    flash.now[:notice] = I18n.t("sessions.destroy.logout")
  end

  private

  def redirect_if_signed_in
    redirect_to dashboard_path if user_signed_in?
  end
end
