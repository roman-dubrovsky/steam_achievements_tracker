require 'rails_helper'

RSpec.describe "Games", type: :request do
  describe "GET /games/new" do
    subject(:do_request) { get "/games/new" }

    let(:steam_api_client) do
      instance_double(Steam::ApiClient, games: games)
    end

    let(:user) { create(:user) }

    let(:games) do
      [
        { "appid" => 1, "name" => "Game 1" },
        { "appid" => 2, "name" => "Game 2" }
      ]
    end

    before do
      allow(Steam::ApiClient).to receive(:new)
        .with(user)
        .and_return(steam_api_client)
    end

    context 'when the user is logged in' do
      before do
        sign_in user
      end

      it "renders the page" do
        do_request

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Add new game")
      end

      context 'when there are not games which can be added' do
        let(:games) { [] }

        it "renders error message" do
          do_request

          expect(response).to have_http_status(:not_found)
          expect(response.body).to include("Sorry, there are not games which can be added for tracking.")
        end
      end
    end

    context 'when the user is not logged in' do
      it 'renders dashboard with logout button' do
        do_request

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
