# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserReviewDecorator do
  let!(:user) { create(:user) }
  let!(:shop) { create(:shop) }
  let!(:user_review) { create(:user_review, user: user, shop: shop) }
  before { ActiveDecorator::Decorator.instance.decorate user_review }

  describe 'UserReviewDecoratorに定義したメソッドが正しく動作すること' do
    describe 'own?(user)' do
      context '引数のUserモデルとUserReviewモデルとアソシエーションしているUserが一致している' do
        it 'trueが返される' do
          expect(user_review.own?(user)).to eq(true), 'trueが返されていません'
        end
      end
    end
  end
end
