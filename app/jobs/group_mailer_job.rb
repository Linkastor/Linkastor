class GroupMailerJob
  include Sidekiq::Worker
  
  #TODO: This method works as long as we have a small number of user and groups, and everything goes fine. If this method fails for any reason, links will not be marked as posted and will be sent again.
  # We need to keep tracks of links sent by user and mark them as posted after each email is sent.
  def perform
    users = User.with_links_to_post
    Rails.logger.info "Found users with pending mail : #{users.count}"
    users.find_each do |user|
      begin
        if user.admin
          user.custom_sources_users.each do |custom_source_user|
            custom_source_user.custom_source.import
          end
        end
        Rails.logger.info "Sending mail to user #{user.email}"
        DigestMailer.send_digest(user: user).deliver_now
      rescue StandardError => e
        Rails.logger.error e
      end
    end
    
    #FIXME: there is a race condition here : Links that are added while we are sending emails will be marked as posted and never sent
    # resolving the above TODO should also fix this problem
    Link.where(posted: false).update_all(posted: true, posted_at: DateTime.now)
  end
end