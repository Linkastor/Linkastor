require "rails_helper"

describe InvitationMailer, :type => :mailer do
  let(:invite) { FactoryGirl.create(:invite, referrer: FactoryGirl.create(:user, name: "Foo bar")) }
  let(:mail) { InvitationMailer.send_invite(invite) }

  it 'renders the subject' do
    expect(mail.subject).to eql('Foo bar invites you to join string on Linkastor')
  end

  it 'renders the receiver email' do
    expect(mail.to).to eql(invite.email)
  end

  it 'renders the sender email' do
    expect(mail.from).to eql(['noreply@linkastor.herokuapp.com'])
  end

  it 'assigns referrer name' do
    expect(mail.body.encoded).to match(invite.referrer.name)
  end
  
  it 'assigns group name' do
    expect(mail.body.encoded).to match(invite.group.name)
  end

  it 'assigns join_url' do
    expect(mail.body.encoded).to match("http://localhost/invites/#{invite.code}")
  end
end
