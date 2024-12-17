# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Devise::Controllers::Helpers

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  protect_from_forgery with: :exception

  before_action :authenticate_user!
end
