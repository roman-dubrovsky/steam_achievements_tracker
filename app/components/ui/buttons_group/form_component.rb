# frozen_string_literal: true

class Ui::ButtonsGroup::FormComponent < ViewComponent::Base
  attr_reader :form, :back, :action

  def initialize(form:, action: nil, back: nil)
    @form = form
    @action = action
    @back = back
  end
end
