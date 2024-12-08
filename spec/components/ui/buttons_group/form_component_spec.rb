RSpec.describe Ui::ButtonsGroup::FormComponent, type: :component do
  context 'when renders component for the form' do
    subject(:rendered_component) do
      render_inline(described_class.new(path: form))
    end

    let(:form) { instance_double(SimpleForm::FormBuilder) }

    before do
      mock_component(Ui::Buttons::SecondaryComponent, path: :back, method: :get) do
        "<div>BackButton</div>"
      end

      mock_component(Ui::Buttons::PrimaryComponent, path: form) do
        "<div>SubmitButton</div>"
      end
    end

    it 'renders back button' do
      is_expected.to have_css('div', text: 'BackButton')
    end

    it 'renders submit button' do
      is_expected.to have_css('div', text: 'SubmitButton')
    end
  end

  context 'when renders component for post action with no default behavior' do
    subject(:rendered_component) do
      render_inline(described_class.new(path: path, back_path: back_path))
    end

    let(:path) { Faker::Internet.url }
    let(:back_path) { Faker::Internet.url }

    before do
      mock_component(Ui::Buttons::SecondaryComponent, path: back_path, method: :get) do
        "<div>BackButton</div>"
      end

      mock_component(Ui::Buttons::PrimaryComponent, path: path) do
        "<div>SubmitButton</div>"
      end
    end

    it 'renders back button' do
      is_expected.to have_css('div', text: 'BackButton')
    end

    it 'renders submit button' do
      is_expected.to have_css('div', text: 'SubmitButton')
    end
  end
end
