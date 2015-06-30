class FetchMetaJob
  def fetch
    links = Link.where(:description => nil)
    links.each do |link|
      link.fetch_meta
      link.save
    end
  end
end