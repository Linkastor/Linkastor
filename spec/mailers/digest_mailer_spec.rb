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
  end
end