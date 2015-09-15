class FetchMetaJob
  include Sidekiq::Worker
  
  def perform(link_id)
    link = Link.find(link_id)
    Rails.logger.debug "Fetching meta for link #{link.url}"

    update_meta!(link)
    RemoveDuplicateJob.new.perform(link.id)
  end

  def update_meta!(link)
    #FIXME : we should let this crash when page is unavailabe (so it can be retried), but find a way to not report this in sentry
    begin
      page = Mechanize.new.get(link.url).try(:parser)
    rescue StandardError => e
      Rails.logger.error e.message
      return
    end

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

    if link.wordcount == nil
      res = []
      page.traverse{ |x| res << x if x.text? and not x.text =~ /^\s*$/ }
      link.wordcount = WordsCounted.count(res.join(" ")).word_count
    end

    link.save
  end
end