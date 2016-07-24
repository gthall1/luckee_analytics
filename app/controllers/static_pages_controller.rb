class StaticPagesController < ApplicationController

    def main
        @active = "main"
        @total = TotalDatum.first
        @latest_users = User.order("user_created desc").limit(7)
        @recent_cash_outs = CashOut.order('cash_out_date desc').limit(50)
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
        @total_users = User.count
        users_beginning_week = User.where(:user_created => User.first.user_created..Time.now.beginning_of_week).size
        @weekly_user_goal = (users_beginning_week.to_f * 0.1).to_i #10 percent goal
        @weekly_active_user_goal = prev_week_active + (prev_week_active * 0.1).to_i
        @total = WeeklyDatum.last

    end

    def custom
      if params[:start] && !params[:start].blank? && params[:end] && !params[:end].blank?
        @start_date = DateTime.new(params[:start]["date(1i)"].to_i,params[:start]["date(2i)"].to_i,params[:start]["date(3i)"].to_i).beginning_of_day
        @end_date = DateTime.new(params[:end]["date(1i)"].to_i,params[:end]["date(2i)"].to_i,params[:end]["date(3i)"].to_i).beginning_of_day
      else
        @start_date = (Time.now - 1.week).beginning_of_day
        @end_date = Time.now.end_of_day
      end
        @dates = DailyDatum.where(:date => @start_date..@end_date).order('date asc')

        @games_played = @dates.sum(:games_played)
        @time_spent_playing = (@dates.sum(:time_spent_playing).to_f/60.to_f/60.to_f).round(2)
        @credits_earned =  @dates.sum(:credits_earned)
        @cash_outs = @dates.sum(:cash_outs)
        @cash_payed = @dates.sum(:cash_payed_out)
        @credits_per_minute = @dates.average(:credits_per_minute).round(2)
        @desktop_arrivals = @dates.sum(:desktop_arrivals)
        @mobile_arrivals = @dates.sum(:mobile_arrivals)
        @total_arrivals = @dates.sum(:arrivals)
        @sign_ups = @dates.sum(:sign_ups)
        @active_users = @dates.sum(:active_users)
        @surveys = @dates.sum(:surveys)
        
    end

    def monthly
        if params[:start] && !params[:start].blank? && params[:end] && !params[:end].blank?
          @start_date = DateTime.new(params[:start]["date(1i)"].to_i,params[:start]["date(2i)"].to_i,params[:start]["date(3i)"].to_i).beginning_of_day
          @end_date = DateTime.new(params[:end]["date(1i)"].to_i,params[:end]["date(2i)"].to_i,params[:end]["date(3i)"].to_i).beginning_of_day
          @all_months = MonthlyDatum.where(:date => start_date..end_date).order('date desc')
          @some_months = MonthlyDatum.where(:date => start_date..end_date).order('date asc')

        else
          @start_date = (Time.now-1.week).strftime('%F')
          @end_date = (Time.now).strftime('%F')
          @all_months = MonthlyDatum.all.order('date desc')
          @some_months = MonthlyDatum.where(:date => Time.now - 6.months..Time.now).order('date asc')
          @total = MonthlyDatum.last
        end

       # @all_months = MonthlyDatum.all.order('date desc')
       # @some_months = MonthlyDatum.where(:date => Time.now - 6.months..Time.now).order('date asc')
        @active = "monthly"
        @total_users = User.count
        week1 = @total_users + (@total_users.to_f * 0.25).to_i #25 percent goal
        week2 = week1 + (week1.to_f * 0.25).to_i 
        week3 = week2 + (week2.to_f * 0.25).to_i 
        goal =  (week3.to_f * 0.25).to_i 

        @monthly_user_goal = goal 
        @monthly_active_user_goal = (@total_users.to_f * 0.5).to_i

    end

end
