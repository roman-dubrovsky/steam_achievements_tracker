RSpec.describe Game::CardComponent, type: :component do
  subject(:rendered_component) { render_inline Game::CardComponent.new(game: game.reload) }

  let(:game) { create(:game) }

  let(:achievements_count) { rand(3..5) }

  before do
    achievements_count.times do
      create(:achievement, game: game)
    end

    mock_component(Game::Card::AchievementsInfoComponent, completed_count: 0, count: achievements_count) do
      "<li>Achievements</li>"
    end
  end

  it 'renders component with main info' do
    expect(rendered_component).to have_css("div.flex.bg-darkblue-500.p-2")
    expect(rendered_component).to have_css("div.font-extrabold.text-lg h4", text: game.name)
  end

  it 'renders game logo' do
    expect(rendered_component).to have_css("div.w-logo img[src='#{game.image}']")
  end

  it 'renders achievements information' do
    expect(rendered_component).to have_css('li', text: "Achievements")
  end
end
