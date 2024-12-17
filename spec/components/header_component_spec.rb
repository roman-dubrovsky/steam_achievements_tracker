# frozen_string_literal: true

RSpec.describe HeaderComponent, type: :component do
  let(:logout_path) { "/logout" }
  let(:login_path) { "/auth/steam" }

  context "when the user is signed in" do
    subject { render_inline(described_class.new(current_user:)) }

    let(:current_user) { build(:user) }

    let(:nickname) { current_user.nickname }
    let(:avatar_url) { current_user.avatar_url }

    it "renders the user's avatar" do
      is_expected.to have_css("img[src='#{avatar_url}'][alt='#{nickname}']")
    end

    it "renders the user's nickname" do
      is_expected.to have_text(nickname)
    end

    it "renders the logout button" do
      is_expected.to have_text("Logout")
      is_expected.to have_css("form[action='#{logout_path}'][method='post']")
    end

    it "does not render the login button" do
      is_expected.not_to have_text("Sign in with Steam")
    end
  end

  context "when the user is not signed in" do
    subject { render_inline(described_class.new(current_user:)) }

    let(:current_user) { nil }

    it "does not render the user's avatar" do
      is_expected.not_to have_css("img")
    end

    it "does not render the logout button" do
      is_expected.not_to have_text("Logout")
    end

    it "renders the login button" do
      is_expected.to have_text("Sign in with Steam")
      is_expected.to have_css("form[action='#{login_path}'][method='post']")
    end
  end
end
