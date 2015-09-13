class FetchMetaJob
  include Sidekiq::Worker
  
  def perform(link_id)
    link = Link.find(link_id)
    Rails.logger.debug "Fetching meta for link #{link.url}"

    begin
      update_meta!(link)
    rescue StandardError => e
      Rails.logger.error e.message
    end
  end

  def update_meta!(link)
    page = Mechanize.new.get(link.url).try(:parser)
    return if page.nil?

    if link.description == nil
      og_descriptions = page.xpath('//meta[@property="og:description"]')
      if og_descriptions.length > 0
        link.description = og_descriptions[0][:content]
      end
    end

    if link.image_url == nil
      og_images = page.xpath('//meta[@property="og:image"]')
      if og_images.length > 0
        link.image_url = og_images[0][:content]
      end
    end

    link.save
  end
end