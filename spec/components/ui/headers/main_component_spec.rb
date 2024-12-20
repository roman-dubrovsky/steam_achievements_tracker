# frozen_string_literal: true

RSpec.describe Ui::Headers::MainComponent, type: :component do
  subject(:rendered_component) do
    render_inline(described_class.new) do
      title
    end
  end

  let(:title) { Faker::Lorem.sentence }

  it "renders header with correct classes and content" do
    is_expected.to have_css("h1.text-3xl.mb-5.font-bold", text: title)
  end
end
