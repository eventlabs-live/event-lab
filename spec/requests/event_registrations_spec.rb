require 'rails_helper'

RSpec.describe "Registrations", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/event_registrations/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/event_registrations/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /index" do
    it "returns http success" do
      get "/event_registrations/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/event_registrations/show"
      expect(response).to have_http_status(:success)
    end
  end

end
