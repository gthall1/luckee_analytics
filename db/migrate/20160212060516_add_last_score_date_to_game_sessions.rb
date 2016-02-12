class AddLastScoreDateToGameSessions < ActiveRecord::Migration
  def change
    add_column :game_sessions, :last_score_date, :datetime
  end
end
