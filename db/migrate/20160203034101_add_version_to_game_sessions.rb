class AddVersionToGameSessions < ActiveRecord::Migration
  def change
    add_column :game_sessions, :version, :integer
  end
end
