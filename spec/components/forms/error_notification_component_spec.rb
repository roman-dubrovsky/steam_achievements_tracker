RSpec.describe Forms::ErrorNotificationComponent, type: :component do
  subject(:render) { render_inline described_class.new(message: message) }

  context 'when message is passed' do
    let(:message) { "Game could not be added due to invalid input" }

    it "renders the error notification with the given message" do
      render
      expect(rendered_content).to have_css("div.bg-red-100.border-red-400.text-red-700")
      expect(rendered_content).to include(message)
    end
  end

  context "when message is not passed" do
    let(:message) { nil }

    it "does not render anything if the message is empty" do
      render
      expect(rendered_content).to be_empty
    end
  end
end
