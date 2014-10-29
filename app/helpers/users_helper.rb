module UsersHelper

  # from a partnership, get user_id distinct from current_user
  def get_friend(partnership)
    partnership.user1_id == current_user.id ? User.where(id: partnership.user2_id).first: User.where(id: partnership.user1_id).first
  end

end
