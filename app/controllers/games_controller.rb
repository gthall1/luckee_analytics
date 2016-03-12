class GamesController < ApplicationController

    def index
        @total = TotalDatum.first
        @games = Game.where.not(device_type:nil)
        @game_sessions = GameSession.where(:game_session_created => Time.now-1.month..Time.now-15.minutes).order('id desc').limit(500)
        @weekly_games = WeeklyDatum.select("date, games_played").where(:date => Time.now-18.weeks..Time.now) #for weekly growth chart
        
        all_sessions = GameSession.select("count(*), game_id").group("game_id")
        @pie_data = @games.map{|g|   
             {label: g.name,  value: g.total_games_played }
           }

        @pie_time_data = @games.map{|g|   
             {label: g.name,  value: (g.total_time_spent_on_game.to_f/60.to_f/60.to_f).round(2) }
           }   
    
    end

    def show
        @game = Game.find(params[:id])
        @game_sessions = GameSession.where(game_id:@game.id)
        @last_bunch_sessions = GameSession.where(game_id:@game.id).order('id desc').limit(1000)
    end
end
