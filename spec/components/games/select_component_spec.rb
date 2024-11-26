RSpec.describe Games::SelectComponent, type: :component do
  subject(:rendered_component) do
    render_inline(described_class.new(form: form, attribute: attribute, games: games))
  end

  let(:games) do
    [
      { "appid" => 1, "name" => "Game 1" },
      { "appid" => 2, "name" => "Game 2" }
    ]
  end

  let(:form) { double("FormBuilder") } # Mock for SimpleForm builder
  let(:attribute) { :app_id }

  before do
    allow(form).to receive(:input).and_return('<input type="hidden" name="game_selection[app_id]" />'.html_safe)
  end

  it "renders the autocomplete input field" do
    expect(rendered_component).to have_css("input[type='text'][placeholder='Search for a game...']")
    expect(rendered_component).to have_css("input[data-autocomplete-target='input']")
  end

  it "renders the hidden field for app_id" do
    expect(rendered_component).to have_css("input[type='hidden'][name='game_selection[app_id]']", visible: false)
  end

  it "includes games data as JSON in the data attribute" do
    expect(rendered_component).to have_css("div[data-controller='autocomplete']")
    expect(rendered_component).to have_css("div[data-autocomplete-games='#{games.to_json}']")
  end

  it "renders the dropdown container" do
    expect(rendered_component).to have_css("ul[data-autocomplete-target='list']", visible: false)
  end

  it "applies Tailwind CSS classes" do
    expect(rendered_component).to have_css("div.relative.w-full")
    expect(rendered_component).to have_css("input.form-input.w-full.border.border-gray-300.rounded-lg.p-2")
    expect(rendered_component).to have_css("ul.absolute.bg-white.border.border-gray-300.mt-1.w-full.rounded-lg.shadow-lg.z-10")
  end
end
