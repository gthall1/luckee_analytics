class GamesController < ApplicationController

    def index
        @total = TotalDatum.first
        @games = Game.all
        @game_sessions = GameSession.where(:game_session_created => Time.now-1.month..Time.now-15.minutes).order('id desc').limit(500)
        @weekly_games = WeeklyDatum.select("date, games_played").where(:date => Time.now-18.weeks..Time.now) #for weekly growth chart
        
        all_sessions = GameSession.select("count(*), game_id").group("game_id")
        @pie_data = all_sessions.map{|g|   
             {label: g.game.name,  value: g.count }
           }
    end

    def show
        @game = Game.find(params[:id])
    end
end
