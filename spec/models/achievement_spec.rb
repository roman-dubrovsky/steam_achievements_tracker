RSpec.describe Achievement do
  subject { build(:achievement) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:uid) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:icon) }
    it { is_expected.to validate_presence_of(:icongray) }
    it { is_expected.to validate_uniqueness_of(:uid).scoped_to(:game_id) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:game) }
  end
end
