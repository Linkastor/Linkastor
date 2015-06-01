class Clock
  attr_accessor :on_alarm
  include Celluloid
  
  def initialize(crontab:)
    @alarm = CronParser.new(crontab: crontab)
  end

  def tick
    loop do
      sleep 60
      @on_alarm.call if @on_alarm && @alarm.fire?
    end
  end
end