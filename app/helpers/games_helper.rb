module GamesHelper

  def partner(game)
    partnership = Partnership.where(game_id: game.id).first
    partnership.user1_id == current_user.id ? User.where(id: partnership.user2_id).first : User.where(id: partnership.user1_id).first
  end

  def status(game)
    game.end.present? ? 'Finished' : 'Active'
  end
end
