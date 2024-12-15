RSpec.describe Game::Card::AchievementsInfoComponent, type: :component do
  subject(:rendered_component) do
    render_inline(described_class.new(completed_count: completed_count, count: count))
  end

  let(:completed_count) { rand(0..100) }
  let(:count) { rand(0..100) + completed_count }

  let(:percent) { (completed_count.to_f / count * 100).to_i }

  it "renders the achievements title" do
    expect(rendered_component).to have_css("h6.font-bold", text: "Achievements")
  end

  it "renders the achievements count with the correct values" do
    expect(rendered_component).to have_css(
      "span.text-gray-200",
      text: "#{completed_count} from #{count}"
    )
  end

  it "renders the progress bar with the correct attributes" do
    expect(rendered_component).to have_css(
      "progress.achievements-progress-bar[value='#{completed_count}'][max='#{count}']"
    )
  end

  it "renders the progress percentage inside the progress bar" do
    expect(rendered_component).to have_text("#{percent}%")
  end

  describe 'when game does not have achievements' do
    let(:completed_count) { 0 }
    let(:count) { 0 }

    it 'does not render component' do
      expect(rendered_component.to_html).to be_empty
    end
  end
end
