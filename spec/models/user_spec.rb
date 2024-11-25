RSpec.describe User do
  describe "validations" do
    it { is_expected.to validate_presence_of(:steam_uid) }
    it { is_expected.to validate_presence_of(:nickname) }
    it { is_expected.to validate_presence_of(:avatar_url) }
    it { is_expected.to validate_uniqueness_of(:steam_uid) }
  end
end
