class FetchMetaJob
  def fetch
    links = Link.where("description IS NULL OR image_url IS NULL")
    links.each do |link|
      link.fetch_meta
      link.save
    end
  end
end