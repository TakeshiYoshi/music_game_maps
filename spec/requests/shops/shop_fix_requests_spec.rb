require 'rails_helper'

RSpec.describe "Shops::ShopFixRequests", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/shops/shop_fix_requests/new"
      expect(response).to have_http_status(:success)
    end
  end

end
