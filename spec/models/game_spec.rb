require 'rails_helper'

RSpec.describe Game, type: :model do
  it 'ゲームタイトルは必須項目であること' do
    game = build(:game, title: nil)
    game.valid?
    expect(game.errors[:title]).to include('を入力してください')
  end

  it 'ゲームタイトルは一意であること' do
    game = create(:game)
    another_game = build(:game, title: game.title)
    another_game.valid?
    expect(another_game.errors[:title]).to include('はすでに存在します')
  end
end
