class UsersController < ApplicationController

    def index
        @users = User.all
        @weekly_users = WeeklyDatum.select("date, total_users").where(:date => Time.now-18.weeks..Time.now) #for weekly growth chart
    end

    def show
        @user = User.find(params[:id])
        @arrivals = Arrival.where(user_id:@user.id)
        @game_sessions = GameSession.select("count(*), game_id").where(user_id:@user.id).group("game_id")
        @pie_data = @game_sessions.map{|g|   
             {label: Game.where(id:g.game_id).first.name,  value: g.count }
           }
    end
end