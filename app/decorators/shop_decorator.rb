# frozen_string_literal: true

module ShopDecorator
  def opening_time?
    return 'no-data' if opening_hours.blank?

    time_ranges = opening_hours_data_convert_to_time_range

    time_ranges.each do |time_range|
      return 'open' if time_range.include? Time.zone.now
    end
    'close'
  end

  def opening_hours_text
    data = opening_hours_data_convert_to_array
    ranges_text = []
    puts data
    data.each do |day|
      # 24時間営業
      if day['close'].blank?
        7.times do |i|
          text = [i, '00:00 〜 24:00']
          ranges_text << text
        end
        break
      end

      open_day = day['open']['day'].to_i
      close_day = day['close']['day'].to_i
      open_time = day['open']['time'].gsub(/(\d{2})(\d{2})/, '\1:\2')
      close_time = day['close']['time'].gsub(/(\d{2})(\d{2})/, '\1:\2')
      # 閉店時刻が0時0分の場合は24:00と表記する
      close_time = '24:00' if close_time == '00:00' && open_day != close_day
      # 閉店時刻が24時以降の場合は翌表記を付ける
      close_time.insert(0, '翌') if close_time != '24:00' && open_day != close_day

      # 閉店時刻が1日以上過ぎている場合は別途登録を行う
      if open_day != close_day && open_day + 1 != close_day && !(open_day == 6 && close_day == 0)
        # 初日登録
        text = [open_day, "#{open_time} 〜 24:00"]
        ranges_text << text
        # 中間登録
        close_day_num = close_day + 6 if open_day > close_day
        1.upto(7) do |i|
          break if open_day + i >= close_day_num
          text = [open_day + i, "00:00 〜 24:00"]
          ranges_text << text
        end
        # 終日登録
        text = [close_day - 1, "00:00 〜 #{close_time} "]
        ranges_text << text
        next
      end

      # 通常登録
      text = [open_day, "#{open_time} 〜 #{close_time}"]
      ranges_text << text
    end
    puts ranges_text.inspect
    ranges_text
  end

  def day_of_week_convert_to_text_from_num(num)
    day_of_week = ['日曜日', '月曜日', '火曜日', '水曜日', '木曜日', '金曜日', '土曜日']
    day_of_week[num]
  end

  def opening_hours_data_convert_to_array
    data = opening_hours
    data = data.gsub('[', '').gsub(']', '')
    data = data.split(', {"c').map { |ary| ary[0] != '{' ? "{\"c#{ary}" : ary }
    data = data.map { |ary| ary.gsub('=>', ':') }
    data = data.map { |ary| JSON.parse ary }
  end

  def opening_hours_data_convert_to_time_range
    data = opening_hours_data_convert_to_array
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
    time_ranges
  end
end
