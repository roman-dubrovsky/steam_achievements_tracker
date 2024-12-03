RSpec.describe Ui::ButtonsGroup::FormComponent, type: :component do
  subject(:rendered_component) do
    render_inline(described_class.new(form: form))
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
