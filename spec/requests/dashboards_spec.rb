require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  describe "GET /dashboard" do
    subject(:do_request) { get "/dashboard" }

    context 'when the user is logged in' do
      let(:user) { create(:user) }

      before do
        sign_in user
      end

      it "renders the page" do
        do_request

        expect(response).to have_http_status(:ok)
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
