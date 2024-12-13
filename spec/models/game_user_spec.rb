RSpec.describe GameUser do
  subject { build(:game_user) }

  describe "validations" do
    it { is_expected.to validate_uniqueness_of(:game).scoped_to(:user_id) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:game) }
    it { is_expected.to have_many(:achievement_users).dependent(:destroy) }
  end
end
