require "rails_helper"

describe DigestMailer, :type => :mailer do
  let(:user) { FactoryGirl.create(:user_with_group) }
  let(:mail) { DigestMailer.send_digest(user: user) }
  
  context "user with links to post" do
    before(:each) do
      @link = FactoryGirl.create(:link, group: user.groups.first, posted: false)
    end
    
    it 'renders the subject' do
      expect(mail.subject).to eql('Yummy ! Your Linkastor daily digest')
    end
    
    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end
    
    it 'assigns user name' do
      expect(mail.body.encoded).to match(user.name)
    end
    
    it 'assigns link url' do
      expect(mail.body.encoded).to match(@link.url)
    end

    context "not connected to pocket" do
      it "should not include pocket link" do
        expect(mail.body.encoded).to_not match("pocket")
      end
    end

    context "connected to pocket" do
      before(:each) do
        user.admin=true
        user.authentication_providers.create!(provider: "pocket", uid: "foo", token: "bar") 
      end

      it "should include pocket link" do
        expect(mail.body.encoded).to match("pocket")
      end
    end
  end
end