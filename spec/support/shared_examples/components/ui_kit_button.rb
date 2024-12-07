RSpec.shared_examples "UIkits button" do |specific_classes|
  let(:path) { "/test_path" }
  let(:method) { :delete }
  let(:content) { "Click Me" }

  subject do
    render_inline(described_class.new(path: path, method: method)) { content }
  end

  context "when renders a button" do
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

  context "when renders a link" do
    let(:method) { :get }

    it "renders the link with the correct path" do
      expect(subject).to have_css("a[href='#{path}']")
    end

    it "applies the correct CSS classes" do
      expect(subject).to have_css(
        "a.py-2.px-4.rounded-xl.flex.justify-between.items-center.#{specific_classes}"
      )
    end

    it "renders the provided content" do
      expect(subject).to have_text(content)
    end
  end

  context "when renders button for form builder" do
    let(:path) { builder }

    let(:form_object) { instance_double("FormObject") }
    let(:view_context) { ActionView::Base.new(ActionController::Base.view_paths, {}, self) }
    let(:builder) { SimpleForm::FormBuilder.new(:example, form_object, view_context, {}) }

    it "applies the correct CSS classes" do
      expect(subject).to have_css(
        "button.py-2.px-4.rounded-xl.flex.justify-between.items-center.#{specific_classes}"
      )
    end

    it "renders the provided content" do
      expect(subject).to have_text(content)
    end
  end
end
