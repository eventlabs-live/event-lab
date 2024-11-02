require 'rails_helper'

RSpec.describe "TicketTypes", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/ticket_types/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/ticket_types/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/ticket_types/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/ticket_types/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/ticket_types/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
