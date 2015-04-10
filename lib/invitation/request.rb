module Invitation
  class Request
    def initialize(referrer:, group:)
      @referrer = referrer
      @group = group
      @callback = Callback.new
    end
    
    def send(emails:)
      yield @callback if block_given?
      emails = parse_emails(emails: emails)
      create_invites(emails: emails)
    end
     
    def parse_emails(emails:)
      return [] if emails.nil?
      emails.split(";").map(&:strip)
    end

    def create_invites(emails:)
      invites = []
      
      begin
        ActiveRecord::Base.transaction do
          emails.each do |email|
            code = SecureRandom.hex(10)
            invites << @referrer.invites.create!(email: email, 
                                                  code: code,
                                                  group: @group)
          end
          @callback.on_valid_emails.try(:call)
        end
      rescue ActiveRecord::RecordInvalid => e
        invites = []
        @callback.on_invalid_email.try(:call, e.record.email)
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
  
  class Callback
    attr_accessor :on_invalid_email, :on_valid_emails
    
    def invalid_email(&block)
      @on_invalid_email = block
    end
    
    def valid_emails(&block)
      @on_valid_emails = block
    end
  end
end