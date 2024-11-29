# frozen_string_literal: true

class Ui::Buttons::BaseComponent < ViewComponent::Base
  attr_reader :path, :method

  def initialize(path:, method: :post)
    @path = path
    @method = method
  end

  def get?
    method.to_sym == :get
  end
end
