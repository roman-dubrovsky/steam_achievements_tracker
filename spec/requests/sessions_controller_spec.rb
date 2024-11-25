RSpec.describe "Sessions", type: :request do
  describe "POST /auth/:provider/callback" do
    subject(:do_request) { post "/auth/steam/callback" }

    let(:auth_hash) do
      {
        "uid" => uid,
        "info" => {
          "nickname" => nickname,
          "image" => image
        }
      }
    end

    let(:uid) { Faker::Crypto.md5 }
    let(:nickname) { Faker::Name.name }
    let(:image) { Faker::Internet.url }

    before do
      OmniAuthCallbackMocker.new(provider: :steam)
        .call(auth: auth_hash)
    end

    context "when the user does not exist" do
      it "creates a new user and signs them in" do
        expect { do_request }.to change(User, :count).by(1)

        user = User.last
        expect(user.steam_uid).to eq(auth_hash["uid"])
        expect(user.nickname).to eq(auth_hash["info"]["nickname"])
        expect(user.avatar_url).to eq(auth_hash["info"]["image"])

        expect(response).to redirect_to(root_path)
      end
    end

    context "when the user exists" do
      let!(:existing_user) { create(:user, steam_uid: uid) }

      it "signs in the user and updates their information" do
        expect { do_request }.not_to change(User, :count)

        existing_user.reload
        expect(existing_user.nickname).to eq(auth_hash["info"]["nickname"])
        expect(existing_user.avatar_url).to eq(auth_hash["info"]["image"])

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE /logout" do
    subject(:do_request) { delete logout_path }

    let(:user) { create(:user) }

    before do
      sign_in user
    end

    it "logs out the user and redirects to the root path" do
      do_request

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Sign in with Steam")
    end
  end

  describe "GET /" do
    subject(:do_request) { get root_path }

    it "renders the login page" do
      do_request

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Sign in with Steam")
    end

    context 'when the user is logged in' do
      let(:user) { create(:user) }

      before do
        sign_in user
      end

      it 'renders dashboard with logout button' do
        do_request

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Logout")
      end
    end
  end
end
