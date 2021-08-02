require 'rails_helper'

RSpec.describe ShopDecorator do
  describe 'ShopDecoratorに定義したメソッドが正しく動作すること' do
    # 営業時間が以下の通りのモデルを作成
    # 日曜日  0:00 ~ 28:00
    # 月曜日 10:00 ~ 28:00
    # 火曜日 10:00 ~ 28:00
    # 水曜日 10:00 ~ 28:00
    # 木曜日 10:00 ~ 28:00
    # 金曜日 10:00 ~ 24:00
    # 土曜日  0:00 ~ 24:00
    let(:shop) { create(:shop, opening_hours: "[{\"close\"=>{\"day\"=>2, \"time\"=>\"0400\"}, \"open\"=>{\"day\"=>1, \"time\"=>\"1000\"}}, {\"close\"=>{\"day\"=>3, \"time\"=>\"0400\"}, \"open\"=>{\"day\"=>2, \"time\"=>\"1000\"}}, {\"close\"=>{\"day\"=>4, \"time\"=>\"0400\"}, \"open\"=>{\"day\"=>3, \"time\"=>\"1000\"}}, {\"close\"=>{\"day\"=>5, \"time\"=>\"0400\"}, \"open\"=>{\"day\"=>4, \"time\"=>\"1000\"}}, {\"close\"=>{\"day\"=>1, \"time\"=>\"0400\"}, \"open\"=>{\"day\"=>5, \"time\"=>\"1000\"}}]") }
    before { ActiveDecorator::Decorator.instance.decorate shop }

    describe 'opening_time?' do
      context '現在時刻が営業時間外' do
        it '文字列「close」が返される' do
          travel_to('2021-7-26 8:00'.to_time) do
            expect(shop.opening_time?).to eq 'close'
          end
        end
      end

      context '現在時刻が営業時間内' do
        it '文字列「open」が返される' do
          travel_to('2021-7-26 10:00'.to_time) do
            expect(shop.opening_time?).to eq 'open'
          end
        end
      end

      context 'shopモデルに営業時間データが存在しない' do
        it '文字列「no-data」が返される' do
          shop.update!(opening_hours: nil)
          expect(shop.opening_time?).to eq 'no-data'
        end
      end
    end

    describe 'opening_hours_text' do
      it '文字列で保存されている営業時間のデータが日本語表記の営業時間の配列に変換される' do
        ary = shop.opening_hours_text
        expect(ary.class).to eq Array
        ary.each do |n, string|
          # [n, XX:XX 〜 XX:XX] の形式で変換される
          expect(n.class).to eq Integer
          expect(string.class).to eq String
        end
      end
    end

    describe 'day_of_week_convert_to_text_from_num' do
      context '現在の曜日が月曜日の場合' do
        it '文字列「月曜日」が返される' do
          travel_to('2021-7-26 10:00'.to_time) do
            expect(shop.day_of_week_convert_to_text_from_num(Time.zone.now.wday)).to eq '月曜日'
          end
        end
      end
    end

    describe 'opening_hours_data_convert_to_array' do
      it '文字列で保存されている営業時間のデータがハッシュの配列に変換される' do
        ary = shop.opening_hours_data_convert_to_array
        expect(ary.class).to eq Array
        ary.each do |hash|
          expect(hash.class).to eq Hash
        end
      end
    end

    describe 'opening_hours_data_convert_to_time_range' do
      it '文字列で保存されている営業時間のデータがRange型の配列に変換される' do
        ary = shop.opening_hours_data_convert_to_time_range
        expect(ary.class).to eq Array
        ary.each do |range|
          expect(range.class).to eq Range
        end
      end
    end

    # get_photo_urlメソッドは外部APIが使用するためテストは行いません。
  end
end
