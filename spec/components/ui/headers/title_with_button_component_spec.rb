# frozen_string_literal: true

RSpec.describe Ui::Headers::TitleWithButtonComponent, type: :component do
  subject(:rendered_component) do
    render_inline described_class.new(title:, button_href:, button_title:)
  end

  let(:title) { "Titles" }
  let(:button_title) { "Add Title" }
  let(:button_href) { Faker::Internet.url }

  it "renders flex container" do
    is_expected.to have_css("div.flex.justify-between.mb-5")
  end

  it "renders title" do
    is_expected.to have_css("h1.text-3xl.mb-5.font-bold", text: title)
  end

  it "renders button" do
    is_expected.to have_css("a[href='#{button_href}']", text: button_title)
  end
end
