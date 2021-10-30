# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameMachineDecorator do
  let!(:game_machine) { create(:game_machine) }
  before { ActiveDecorator::Decorator.instance.decorate game_machine }

  describe 'count_info_exist?' do
    # countが99の時は台数情報不明と定義しています。
    context 'countが99のとき' do
      it 'falseが返される' do
        game_machine.update(count: 99)
        expect(game_machine.count_info_exist?).to eq false
      end
    end

    context 'countが99以外のとき' do
      it 'trueが返される' do
        game_machine.update(count: 0)
        expect(game_machine.count_info_exist?).to eq true
      end
    end
  end
end
