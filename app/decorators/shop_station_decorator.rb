# frozen_string_literal: true

module ShopStationDecorator
  def minutes_text
    walking_speed = 80.0
    car_speed = 400.0

    if 2000 >= distance
      # 距離2km以下の場合は徒歩表記
      "(徒歩#{(distance/walking_speed).ceil}分)"
    else
      # 距離2km以上の場合は車表記
      "(車#{(distance/car_speed).ceil}分)"
    end
  end
end
