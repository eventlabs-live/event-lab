require 'rails_helper'

RSpec.describe "Tickets", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/tickets/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/tickets/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/tickets/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/tickets/create"
      expect(response).to have_http_status(:success)
    end
  end

end
