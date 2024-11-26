# frozen_string_literal: true

class Buttons::SteamComponent < ViewComponent::Base
  attr_reader :path, :method

  def initialize(path:, method: :post)
    @path = path
    @method = method
  end
end
