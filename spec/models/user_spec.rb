RSpec.describe User do
  describe "validations" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it { is_expected.to allow_value(Faker::Internet.email).for(:email) }
  end
end
