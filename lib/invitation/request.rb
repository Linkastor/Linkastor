module Invitation
  class Request
    def initialize(referrer: nil, group: nil)
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
      begin
        ActiveRecord::Base.transaction do
          invites = emails.map do |email|
            code = SecureRandom.hex(10)
            @referrer.invites.create!(email: email, code: code, group: @group)
          end
          send_emails(invites: invites)
          @callback.on_valid_emails.try(:call)
        end
      rescue ActiveRecord::RecordInvalid => e
        @callback.on_invalid_email.try(:call, e.record.email) if e.record.errors.added?(:email, 'is not a valid email address')
        @callback.on_invite_already_exist.try(:call, e.record.email) if e.record.errors.added?(:email, 'has already been taken')
      end
    end
    
    def send_emails(invites:)
      invites.each do |invite|
        InviteMailerJob.new.async.perform(invite)
      end
    end
  end
  
  class Callback
    attr_accessor :on_invalid_email, :on_valid_emails, :on_invite_already_exist
    
    def invite_already_exist(&block)
      @on_invite_already_exist = block
    end
    
    def invalid_email(&block)
      @on_invalid_email = block
    end
    
    def valid_emails(&block)
      @on_valid_emails = block
    end
  end
end