# frozen_string_literal: true

RSpec.describe Users::FindViaSteam do
  subject(:service_call) { described_class.call(auth) }

  let(:auth) do
    {
      "uid" => uid,
      "info" => {
        "nickname" => nickname,
        "image" => image,
      },
    }
  end

  let(:uid) { Faker::Crypto.md5 }
  let(:nickname) { Faker::Name.name }
  let(:image) { Faker::Internet.url }

  describe "#call" do
    context "when the user exists" do
      let(:user) { create(:user) }
      let(:uid) { user.steam_uid }

      it "returns the user" do
        is_expected.to eq user
      end

      it "updates the user's nickname" do
        service_call
        expect(service_call.nickname).to eq(nickname)
      end

      it "updates the user's avatar_url" do
        service_call
        expect(service_call.avatar_url).to eq(image)
      end
    end

    context "when the user does not exist" do
      let(:created_user) { User.last }

      it "creates a new user" do
        expect { service_call }.to change { User.count }.by(1)
      end

      it "returns the created user" do
        is_expected.to eq created_user
      end

      it "sets the user's nickname" do
        service_call
        expect(service_call.nickname).to eq(nickname)
      end

      it "sets the user's avatar_url" do
        service_call
        expect(service_call.avatar_url).to eq(image)
      end
    end
  end
end
