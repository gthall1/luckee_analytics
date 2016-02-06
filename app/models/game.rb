class Game < ActiveRecord::Base
    has_many :game_sessions
end
