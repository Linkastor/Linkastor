require "rails_helper"

describe CronParser do
  before(:each) do 
    DateTime.stubs(:now).returns(DateTime.strptime('2015-02-03T04:05:06', '%Y-%m-%dT%H:%M:%S'))
  end
    
  describe "valid?" do
    it { CronParser.new(crontab: '5 * * * *').valid?.should == true }
    it { expect { CronParser.new(crontab: '* * *') }.to raise_error }
  end
    
  describe "fire?" do
    context "every hour at 5 min" do
      it { CronParser.new(crontab: '5 * * * *').fire?.should == true }
      it { CronParser.new(crontab: '2 * * * *').fire?.should == false }
    end
    
    context "every day at 4am" do
      it { CronParser.new(crontab: '* 4 * * *').fire?.should == true }
      it { CronParser.new(crontab: '* 3 * * *').fire?.should == false }
    end
    
    context "every 3rd day of the month" do
      it { CronParser.new(crontab: '* * 3 * *').fire?.should == true }
      it { CronParser.new(crontab: '* * 2 * *').fire?.should == false }
    end
    
    context "every 2nd month of the year" do
      it { CronParser.new(crontab: '* * * 2 *').fire?.should == true }
      it { CronParser.new(crontab: '* * * 1 *').fire?.should == false }
    end
    
    context "every tuesday" do
      it { CronParser.new(crontab: '* * * * 2').fire?.should == true }
      it { CronParser.new(crontab: '* * * * 1').fire?.should == false }
    end
    
    context "every time" do
      it { CronParser.new(crontab: '* * * * *').fire?.should == true }
    end
  end

end