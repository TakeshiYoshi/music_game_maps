require 'rails_helper'

RSpec.describe "Admin::ShopFixRequests", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/admin/shop_fix_requests/index"
      expect(response).to have_http_status(:success)
    end
  end

end
