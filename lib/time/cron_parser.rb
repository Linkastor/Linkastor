#Supports a subset of the crontab syntax. 'Every' notation is not supported (ex: */5 * * * *)
class CronParser
  REGEX = /(([\d\/,\-]+|\*)\s*){5}/
  CRONTAB_CONSTANT = [:min, :hour, :day, :month, :day_of_week]
  
  def initialize(crontab:)
    @crontab = crontab
    raise "Invalid crontab #{crontab}" unless valid?
  end
  
  def check(interval_type:)
    interval_value = @crontab.split[CRONTAB_CONSTANT.index(interval_type)]
    interval_value == "*" || DateTime.now.send(interval_type.to_s) == interval_value.to_i
  end
  
  def fire?
    check(interval_type: :min) &&
    check(interval_type: :hour) &&
    check(interval_type: :day) &&
    check(interval_type: :month) &&
    check(interval_type: :day_of_week)
  end
  
  def valid?
    REGEX.match(@crontab) != nil
  end
end

class DateTime
  def day_of_week
    cwday
  end
end