RSpec.shared_examples "UIkits button" do |specific_classes|
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
      "button.py-2.px-4.rounded-xl.flex.justify-between.items-center.#{specific_classes}"
    )
  end

  it "renders the provided content" do
    expect(subject).to have_text(content)
  end
end
