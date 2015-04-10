module Invitation
  class Request
  
    def initialize(referrer:, group:)
      @referrer = referrer
      @group = group
    end
    
    def send(emails:)
      emails = parse_emails(emails: emails)
      create_invites(emails: emails)
    end
     
    def parse_emails(emails:)
      return [] if emails.nil?
      emails.split(";").map(&:strip)
    end

    def create_invites(emails:)
      invites = []
      
      #TODO : ajouter un on failure quand on rollback la transaction
      begin
        ActiveRecord::Base.transaction do
          emails.each do |email|
            code = SecureRandom.uuid
            invites << @referrer.invites.create!(email: email, 
                                                      code: code,
                                                      group: @group)
          end
        end
      rescue ActiveRecord::RecordInvalid
        invites = []
      end
      
      send_emails(invites: invites)
      
      return invites
    end
    
    def send_emails(invites:)
      invites.map do |invite|
        InviteMailerJob.new.async.perform(invite)
      end
    end
  end
end