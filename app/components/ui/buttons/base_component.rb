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

  def form?
    path.is_a?(SimpleForm::FormBuilder)
  end

  def button_classes
    [ common_classes, styles ].join(" ")
  end

  def common_classes
    %w[w-fit py-2 px-4 rounded-xl flex justify-between items-center].join(" ")
  end
end
