module DateHelper
  def self.convert_datetime_to_utc(time_zone: nil, date_time: nil)
    ActiveSupport::TimeZone[time_zone].parse(date_time).utc if time_zone.present? && date_time.present?
  end

  def self.time_format(time, type = "string")
    mm, ss = time.divmod(60)
    hh, mm = mm.divmod(60)
    dd, hh = hh.divmod(24)
    return "%d d : %d h : %d m" % [dd, hh, mm] if type == "string"
    return { days: dd, hours: hh, minutes: mm, seconds: ss } if type == "json"
  end

  def self.parse_string_to_datetime(string)
    return Time.zone.parse(string)
  end

  def self.parse_to_datetime(day, time=Time.new)
    date = TimeInterval::DAYS_DICT[day.capitalize]
    Time.parse("#{date.strftime('%F')} #{time.strftime('%T%z')}")
  end

  def self.map_day_to_index(day="Sunday")
    hash = { sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6 }
    return hash[day.downcase.to_sym]
  end

  def self.get_day_name(date)
    Date::DAYNAMES[date.wday]
  end

  def self.date_of_next_day_from(from=Date.today, day)
    date  = Date.parse(day)
    day_index = DateHelper.map_day_to_index(day)
    from_day = DateHelper.get_day_name(from)
    from_index = DateHelper.map_day_to_index(from_day)

    interval_between = day_index - from_index
    if interval_between <= 0
      delta_days = 7 + interval_between ## if day comes after from then look for next week 0 or -ve
    else
      delta_days = interval_between
    end

    from + (delta_days.days)
  end

  def self.get_days_list
    date_from = Date.parse("1-1-2000") #corrsponds to Saturday
    date_to = date_from + 6.days  #corrsponds to Friday
    date_list = (date_from..date_to)
    day_to_date_dict = date_list.map do |date|
      [get_day_name(date), date]
    end
    return day_to_date_dict.to_h
  end

  def self.start_to_end_of(day)
    date = parse_to_datetime(day)
    return date.beginning_of_day..date.end_of_day
  end

  def self.zone_start_and_end_of(day)
    date = TimeInterval::DAYS_DICT[day.capitalize]
    start_date = Time.zone.parse("#{date.strftime('%F')} #{Time.zone.now.beginning_of_day.strftime('%T%z')}")
    end_date = Time.zone.parse("#{date.strftime('%F')} #{Time.zone.now.end_of_day.strftime('%T%z')}")
    return start_date, end_date
  end

  def self.start_of(day)
    date = parse_to_datetime(day)
    return date.beginning_of_day
  end

  def self.noon_of(day)
    date = parse_to_datetime(day)
    return date.noon
  end

  def self.end_of(day)
    date = parse_to_datetime(day)
    return date.end_of_day
  end

  def self.intervals_overlap?(start_a, end_a, start_b, end_b)
    return (start_a < end_b) && (end_a > start_b)
  end

  def self.get_date_at_time(date, time=Time.new)
    Time.parse("#{date.strftime('%F')} #{time.strftime('%T%z')}")
  end

  def self.get_month_abbr_name(month)
    return Date::ABBR_MONTHNAMES[month]
  end

  #doesn't respect number of days
  def self.get_number_of_month_between_two_dates(start_date, end_date)
    (end_date.year * 12 + end_date.month) - (start_date.year * 12 + start_date.month)
  end

  def self.month_and_year_overlap?(start_date, end_date)
    return ((start_date.month == end_date.month) && (start_date.year == end_date.year))
  end

  def self.get_number_of_weeks_between_two_dates(start_date, end_date)
    start_time = start_date.to_time
    end_time = end_date.to_time
    return (end_time - start_time).seconds.in_weeks.to_i.abs
  end

  #counts the end date as part of our duration span hence the addition of 1
  def self.get_number_of_days_between_two_dates(start_date, end_date)
    return (end_date.to_date - start_date.to_date).to_i.abs + 1
  end

  def self.get_week_start_and_end_dates(week_number, week_year)
    return Date.commercial(week_year, week_number, 1).strftime("%a, %d %b %Y"), Date.commercial(week_year, week_number, 7).strftime("%a, %d %b %Y")
  end

  def self.date_intervals_overlap?(first_interval_start_date, first_interval_end_date, second_interval_start_date, second_interval_end_date)
    return (first_interval_start_date.to_date..first_interval_end_date.to_date).overlaps?(second_interval_start_date.to_date..second_interval_end_date.to_date)
  end
end
