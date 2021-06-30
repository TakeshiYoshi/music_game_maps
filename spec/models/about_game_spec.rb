require 'rails_helper'

RSpec.describe AboutGame, type: :model do
  it 'ユーザー投稿とゲームの組み合わせは一意であること' do
    user_review = create(:user_review)
    game = create(:game)
    about_game = create(:about_game, user_review: user_review, game: game)
    another_about_game = build(:about_game, user_review: user_review, game: game)
    another_about_game.valid?
    expect(another_about_game.errors[:user_review_id]).to include('はすでに存在します')
  end
end
