class RemoveDuplicateJob
  include Sidekiq::Worker

  def perform(link_id)
    link = Link.find(link_id)
    Rails.logger.debug "Looking for duplicate for link #{link.url}"

    parent = link.group ? link.group : link.custom_source
    schedule_posts = parent.links.where(posted: false)

    duplicate_link_description = schedule_posts.where(description: link.description)
    if duplicate_link_description.count > 1
      Rails.logger.debug "Found duplicate description in links : #{duplicate_link_description.map(&:id).join(", ")}"
      link.update(posted: true)
      return
    end

    duplicate_link_image = schedule_posts.where(image_url: link.image_url)
    if duplicate_link_image.count > 1
      Rails.logger.debug "Found duplicate images in links : #{duplicate_link_image.map(&:id).join(", ")}"
      link.update(posted: true)
    end
  end
end