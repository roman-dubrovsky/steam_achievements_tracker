# frozen_string_literal: true

class Ui::Containers::FormComponent < ViewComponent::Base
  attr_reader :title

  def initialize(title)
    @title = title
  end
end
