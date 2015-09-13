class RemoveDuplicateJob
  include Sidekiq::Worker

  def perform(link_id)
    link = Link.find(link_id)
    Rails.logger.debug "Looking for duplicate for link #{link.url}"

    parent = link.group || link.custom_source
    schedule_links = parent.links.where(posted: false)

    [:description, :image_url].each do |column|
      duplicate_link = schedule_links.where(column => link.send(column))
      if duplicate_link.count > 1
        Rails.logger.debug "Found duplicate #{column} in links : #{duplicate_link.map(&:id).join(", ")}"
        link.update(posted: true)
      end
    end
  end
end