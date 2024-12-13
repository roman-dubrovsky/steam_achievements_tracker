RSpec.describe Game::CardComponent, type: :component do
  subject(:rendered_component) { render_inline Game::CardComponent.new(game: presenter) }

  let(:game) { build(:game) }
  let(:user) { build(:user) }
  let(:presenter) { Games::CardPresenter.new(game: game, user: user) }

  let(:completed_achievements_count) { rand(0..100) }
  let(:achievements_count) { rand(0..100) }

  before do
    allow(presenter).to receive(:completed_achievements_count).and_return(completed_achievements_count)
    allow(presenter).to receive(:achievements_count).and_return(achievements_count)

    mock_component(Game::Card::AchievementsInfoComponent,
      completed_count: completed_achievements_count,
      count: achievements_count
    ) do
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
