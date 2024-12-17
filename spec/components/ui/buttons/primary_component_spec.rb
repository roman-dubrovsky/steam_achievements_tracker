# frozen_string_literal: true

RSpec.describe Ui::Buttons::PrimaryComponent, type: :component do
  it_behaves_like "UIkits button", "bg-lightgreen-500.text-gray-700.hover\\:bg-gray-700.hover\\:text-lightgreen-500"
end
