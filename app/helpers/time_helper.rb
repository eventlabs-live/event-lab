# app/helpers/time_helper.rb
module TimeHelper
  def next_quarter_hour(time)
    minutes = (time.min / 15 + 1) * 15
    if minutes == 60
      time + (60 - time.min) * 60
    else
      time + (minutes - time.min) * 60
    end
  end

  def quater_hour_time_intervals
    intervals = []
    (0..23).each do |hour|
      ["00", "15", "30", "45"].each do |minute|
        intervals << format('%02d:%s', hour, minute)
      end
    end
    intervals
  end

end