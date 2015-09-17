require "rails_helper"

describe InviteMailerJob do

  describe "perform" do
    it "send an invitation mail" do
      invite = FactoryGirl.create(:invite)
      InvitationMailer.expects(:send_invite).with(invite).returns(stub(deliver_now: nil))
      InviteMailerJob.new.perform(invite.id)
    end
  end
end