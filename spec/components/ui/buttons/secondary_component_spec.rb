# frozen_string_literal: true

RSpec.describe Ui::Buttons::SecondaryComponent, type: :component do
  it_behaves_like "UIkits button", "bg-gray-600.text-white.hover\\:opacity-85"
end
