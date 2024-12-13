RSpec.describe AchievementUser do
  describe "associations" do
    it { is_expected.to belong_to(:game_user) }
    it { is_expected.to belong_to(:achievement) }
  end
end
