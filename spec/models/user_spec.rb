RSpec.describe User do
  describe "validations" do
    it { is_expected.to validate_presence_of(:steam_uid) }
    it { is_expected.to validate_presence_of(:nickname) }
    it { is_expected.to validate_presence_of(:avatar_url) }
    it { is_expected.to validate_uniqueness_of(:steam_uid) }
  end

  describe "associations" do
    it { is_expected.to have_many(:game_users).dependent(:destroy) }
    it { is_expected.to have_many(:games).through(:game_users) }
  end
end
