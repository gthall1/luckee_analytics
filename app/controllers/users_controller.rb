class UsersController < ApplicationController

    def index
        @users = User.all.order('user_created asc')
        @weekly_users = WeeklyDatum.select("date, total_users,active_users").where(:date => Time.now-18.weeks..Time.now).order('date asc') #for weekly growth chart
    end

    def active
        @users = User.where(active:true)
        @weekly_users = WeeklyDatum.select("date, total_users,active_users,user_churn,sign_ups").where(:date => Time.now-(60.days)..Time.now).order('date asc') #for weekly growth chart
        #@weekly_churn = WeeklyDatum.select("date, total_users,active_users").where(:date => Time.now-(30.days)..Time.now).order('date asc') #for weekly growth chart
        
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
