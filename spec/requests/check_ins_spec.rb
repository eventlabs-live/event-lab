require 'rails_helper'

RSpec.describe "CheckIns", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/check_ins/create"
      expect(response).to have_http_status(:success)
    end
  end

end
