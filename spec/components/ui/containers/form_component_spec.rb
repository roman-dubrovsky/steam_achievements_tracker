# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ui::Containers::FormComponent, type: :component do
  subject(:rendered_component) do
    render_inline(described_class.new(title)) do
      content
    end
  end

  let(:title) { Faker::Lorem.sentence }
  let(:content) { Faker::Lorem.sentence }

  it "renders container with correct classes" do
    is_expected.to have_css("div.max-w-r50.mx-auto")
  end

  it "renders header" do
    is_expected.to have_css("h1", text: title)
  end

  it "renders content" do
    is_expected.to have_text(content)
  end
end
