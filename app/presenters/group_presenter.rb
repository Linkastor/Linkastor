class GroupPresenter
  def self.links(group)
    group.links_to_post.includes(:user)
  end

  def self.hasLinkToPost(group)
    group.links_to_post.includes(:user).count > 0
  end
end