RSpec.describe Game do
  describe "validations" do
    it { is_expected.to validate_presence_of(:app_uid) }
    it { is_expected.to validate_uniqueness_of(:app_uid) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:image) }
  end

  describe "associations" do
    it { is_expected.to have_many(:game_users).dependent(:destroy) }
  end
end
