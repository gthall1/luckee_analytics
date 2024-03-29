class UsersController < ApplicationController

    def index
        @users = User.all.order('user_created desc')
        @weekly_users = WeeklyDatum.select("date, total_users,active_users").where(:date => Time.now-18.weeks..Time.now).order('date asc') #for weekly growth chart
    end

    def active
        @users = User.where(active:true)
        @weekly_users = WeeklyDatum.select("date, total_users,active_users,user_churn,sign_ups").where(:date => Time.now-(60.days)..Time.now).order('date asc') #for weekly growth chart
        #@weekly_churn = WeeklyDatum.select("date, total_users,active_users").where(:date => Time.now-(30.days)..Time.now).order('date asc') #for weekly growth chart
        
    end

    def show
        @user = User.find(params[:id])
        @refered_users = User.where(refered_by_id:@user.id)
        @arrivals = Arrival.where(user_id:@user.id)
        @game_sessions = GameSession.select("count(*), game_id").where(user_id:@user.id).group("game_id")
        @pie_data = @game_sessions.map{|g|   
             {label: Game.where(id:g.game_id).first.name,  value: g.count }
           }
        @last_bunch_sessions = GameSession.where(user_id:@user.id).order('game_session_created desc').limit(500)
    end
end
