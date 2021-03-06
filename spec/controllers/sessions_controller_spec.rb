require "spec_helper"

RSpec.describe SessionsController do
  render_views

  before do
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end

  describe "#create" do
    it "should successfully create a user" do
      expect { post :create, provider: :facebook }.
        to change { User.count }.by(1)
    end

    it "should successfully create a session" do
      expect(session[:user_id]).to be_nil

      post :create, provider: :facebook

      expect(session[:user_id]).not_to be_nil
    end

    it "should redirect authorized users to the candidates url" do
      post :create, provider: :facebook

      expect(response).to redirect_to(root_path)
    end
  end

  describe "#destroy" do
    before do
      post :create, provider: :facebook
    end

    it "should successfully destroy a session" do
      expect(session[:user_id]).not_to be_nil

      delete :destroy

      expect(session[:user_id]).to be_nil
    end

    it "should redirect to landing page after destroying session" do
      delete :destroy

      expect(response).to redirect_to(root_path)
    end
  end
end
