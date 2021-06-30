require 'rails_helper'

RSpec.describe PlayingGame, type: :model do
  it 'ユーザーとゲームの組み合わせは一意であること' do
    user = create(:user)
    game = create(:game)
    playing_game = create(:playing_game, user: user, game: game)
    another_playing_game = build(:playing_game, user: user, game: game)
    another_playing_game.valid?
    expect(another_playing_game.errors[:user_id]).to include('はすでに存在します')
  end
end
