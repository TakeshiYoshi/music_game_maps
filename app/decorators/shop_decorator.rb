# frozen_string_literal: true

module ShopDecorator
  def opening_time?
    return 'no-data' if opening_hours.blank?

    # JSONの形に整える
    data = opening_hours
    data = data.gsub('[', '').gsub(']', '')
    data = data.split(', {"c').map { |ary| ary[0] != '{' ? "{\"c#{ary}" : ary }
    data = data.map { |ary| ary.gsub('=>', ':') }
    data = data.map { |ary| JSON.parse ary }

    time_ranges = []

    data.each do |period|
      # 24時間営業の場合
      if period['close'].blank?
        opening_time = (Time.zone.now - Time.zone.today.wday.day).midnight
        closing_time = (opening_time + 6.days).end_of_day
        time_range = opening_time..closing_time
        time_ranges << time_range
        break
      end
      correct_open_day = period['open']['day'] - Time.zone.today.wday
      correct_close_day = period['close']['day'] - Time.zone.today.wday
      correct_close_day = period['close']['day'] - Time.zone.today.wday + 7 if period['open']['day'] > period['close']['day']

      opening_time = Time.zone.parse(period['open']['time'].gsub(/(\d{2})(\d{2})/) { "#{Regexp.last_match(1)}:#{Regexp.last_match(2)}" }) + correct_open_day.days
      closing_time = Time.zone.parse(period['close']['time'].gsub(/(\d{2})(\d{2})/) { "#{Regexp.last_match(1)}:#{Regexp.last_match(2)}" }) + correct_close_day.days

      time_range = opening_time..closing_time
      time_ranges << time_range
    end

    time_ranges.each do |time_range|
      return 'open' if time_range.include? Time.zone.now
    end
    'close'
  end
end
