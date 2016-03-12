class StaticPagesController < ApplicationController

    def main
        @active = "main"
        @total = TotalDatum.first
        @latest_users = User.order("user_created desc").limit(7)
        @recent_cash_outs = CashOut.order('cash_out_date desc').limit(7)
    end

    def daily
        @total = DailyDatum.last
        @all_days = DailyDatum.all.order('date desc')
        @some_days = DailyDatum.where(:date => (Time.now - 2.weeks).beginning_of_day..Time.now).order('date asc')
        #@power_users = GameSession.select(:user_id,:time_played).where(:game_session_created => Time.now.beginning_of_day..Time.now.end_of_day).group(:user_id).order("time_played desc").limit(10)
        @power_users = GameSession.select('user_id, count(*)').where(:game_session_created => Time.now.beginning_of_day..Time.now.end_of_day).group(:user_id).limit(10)
    end

    def weekly
        prev_week_active =WeeklyDatum.order('id desc').second.active_users
        @some_weeks = WeeklyDatum.where(:date => Time.now - 10.weeks..Time.now).order('date asc')
        @all_weeks = WeeklyDatum.all.order('date desc')
        @active = "weekly"
        @total_users = User.all.size
        users_beginning_week = User.where(:user_created => User.first.user_created..Time.now.beginning_of_week).size
        @weekly_user_goal = (users_beginning_week.to_f * 0.1).to_i #10 percent goal
        @weekly_active_user_goal = prev_week_active + (prev_week_active * 0.1).to_i
        @total = WeeklyDatum.last

    end

    def monthly
        @all_months = MonthlyDatum.all.order('date desc')
        @some_months = MonthlyDatum.where(:date => Time.now - 6.months..Time.now).order('date asc')
        @active = "monthly"
        @total_users = User.all.size
        week1 = @total_users + (@total_users.to_f * 0.25).to_i #25 percent goal
        week2 = week1 + (week1.to_f * 0.25).to_i 
        week3 = week2 + (week2.to_f * 0.25).to_i 
        goal =  (week3.to_f * 0.25).to_i 

        @monthly_user_goal = goal 
        @monthly_active_user_goal = (@total_users.to_f * 0.5).to_i

        @total = MonthlyDatum.last
    end

end
