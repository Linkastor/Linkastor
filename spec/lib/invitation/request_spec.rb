require "rails_helper"

describe Invitation::Request do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:group) { FactoryGirl.create(:group) }
  let(:invitation) { Invitation::Request.new(referrer: user, group: group) }
  
  describe "create_invites" do
    context "valid emails" do
      let(:emails) { ["foo@bar.com", "foo1@bar.com"] }
      
      it "creates an invitation" do
        invitation.create_invites(emails: emails)
        
        invite = Invite.last
        invite.email.should == "foo1@bar.com"
        invite.referrer.should == user
        invite.code.should_not == nil
      end
      
      it "returns sent invitations" do
        invitations = invitation.create_invites(emails: emails)
        
        Invite.count.should == 2
        invitations.map(&:email).should == emails
      end
    end
    
    context "invalid email" do
      let(:emails) { ["foo@bar.com", "foobar.com"] }
      
      it "cancels all invitations" do
        invitation.create_invites(emails: emails)
        Invite.count.should == 0
      end
      
      it "returns empty sent invitations" do
        invitations = invitation.create_invites(emails: emails)
        invitations.should == []
      end
    end
  end
  
  describe "parse_emails" do
    it { invitation.parse_emails(emails: "foo@bar.com").should == ["foo@bar.com"] }
    it { invitation.parse_emails(emails: "foo@bar.com; foo1@bar.com").should == ["foo@bar.com", "foo1@bar.com"] }
    it { invitation.parse_emails(emails: "foo@bar.com ;foo1@bar.com").should == ["foo@bar.com", "foo1@bar.com"] }
    it { invitation.parse_emails(emails: "foo@bar.com ; foo1@bar.com").should == ["foo@bar.com", "foo1@bar.com"] }
    it { invitation.parse_emails(emails: "foo@bar.com;foo1@bar.com").should == ["foo@bar.com", "foo1@bar.com"] }
    it { invitation.parse_emails(emails: "foo@bar.com;foo1@bar.com;").should == ["foo@bar.com", "foo1@bar.com"] }
    it { invitation.parse_emails(emails: nil).should == [] }
  end
end