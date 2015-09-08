class LinkPresenter
  def safe_link_title(link)
    ActionController::Base.helpers.strip_tags(link.title)
  end

  def safe_link_description(link)
    ActionController::Base.helpers.strip_tags(link.description).try(:truncate, 335)
  end
end