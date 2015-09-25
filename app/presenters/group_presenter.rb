class GroupPresenter
  def self.links(group)
    group.links_to_post.includes(:user)
  end
end