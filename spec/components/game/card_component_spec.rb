RSpec.describe Game::CardComponent, type: :component do
  subject(:rendered_component) { render_inline Game::CardComponent.new(game: game) }

  let(:game) { create(:game) }

  it 'renders component with main info' do
    expect(rendered_component).to have_css("div.flex.bg-darkblue-500.p-2")
    expect(rendered_component).to have_css("div.font-extrabold.text-lg h4", text: game.name)
  end

  it 'renders game logo' do
    expect(rendered_component).to have_css("div.w-logo img[src='#{game.image}']")
  end
end
