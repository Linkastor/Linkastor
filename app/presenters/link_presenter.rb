class LinkPresenter
  def safe_link_title(link)
    ActionController::Base.helpers.strip_tags(link.title)
  end
end