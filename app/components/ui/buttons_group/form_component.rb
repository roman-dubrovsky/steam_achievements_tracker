# frozen_string_literal: true

class Ui::ButtonsGroup::FormComponent < ViewComponent::Base
  attr_reader :path, :back, :action, :back_path

  def initialize(path:, back_path: :back, action: nil, back: nil)
    @path = path
    @back_path = back_path
    @action = action
    @back = back
  end
end
