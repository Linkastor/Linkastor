class PocketMetaJob
  def fetch
    links = Link.where("description IS NULL OR image_url IS NULL OR wordcount = 0")
    links.each do |link|
      link.fetch_pocket_meta
      link.save
    end
  end
end