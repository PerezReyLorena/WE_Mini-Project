module GamesHelper

  def partner(game)
    partnership = Partnership.where(game_id: game.id).first
    partnership.user1_id == current_user.id ? User.where(id: partnership.user2_id).first : User.where(id: partnership.user1_id).first
  end

  def status(game)
    game.end.present? ? 'Finished' : 'Active'
  end

  def current_user_turn?(game, turn)
    partnership = Partnership.where(game_id: game.id).first
    partnership.user1_id == current_user.id ? current_user_turn = 'B' : current_user_turn = 'W'
    return current_user_turn == turn
  end

  def current_user_color(game)
    partnership = Partnership.where(game_id: game.id).first
    partnership.user1_id == current_user.id ? 'B' : 'W'
  end

end
