RSpec.describe Buttons::SteamComponent, type: :component do
  let(:path) { "/test_path" }
  let(:method) { :delete }
  let(:content) { "Click Me" }

  subject do
    render_inline(described_class.new(path: path, method: method)) { content }
  end

  it "renders the button with the correct path" do
    expect(subject).to have_css("form[action='#{path}'][method='post']")
  end

  it "renders the button with the correct method" do
    expect(subject).to have_css("input[name='_method'][value='#{method}']", visible: false)
  end

  it "applies the correct CSS classes" do
    expect(subject).to have_css(
      "button.bg-black.py-2.px-4.uppercase.rounded-xl.flex.justify-between.items-center.text-white.hover\\:bg-gray-800"
    )
  end

  it "renders the provided content" do
    expect(subject).to have_text(content)
  end
end
