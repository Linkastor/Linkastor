class Invitation
  def initialize(referrer:, group:)
    @referrer = referrer
    @group = group
  end
  
  def send(emails:)
    emails = parse_emails(emails: emails)
    create_invites(emails: emails)
  end
   
  def parse_emails(emails:)
    emails.split(";").map(&:strip)
  end

  def create_invites(emails:)
    sent_invites = []
    
    begin
      ActiveRecord::Base.transaction do
        emails.each do |email|
          code = SecureRandom.uuid
          sent_invites << @referrer.invites.create!(email: email, 
                                                    code: code,
                                                    group: @group)
        end
      end
    rescue ActiveRecord::RecordInvalid
      sent_invites = []
    end
    
    return sent_invites
  end
end