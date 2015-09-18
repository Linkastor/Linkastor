module ApplicationHelper
  def current_user
    controller.current_user
  end

  def is_current_user(user)
    return user.id == current_user.id
  end
end
