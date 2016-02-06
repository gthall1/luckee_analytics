class StaticPagesController < ApplicationController

    def main
        @active = "main"
        @total = TotalDatum.first
    end

    def weekly
        @some_weeks = WeeklyDatum.where(:date => Time.now - 10.weeks..Time.now).order('date asc')
        @all_weeks = WeeklyDatum.all.order('date desc')
        @active = "weekly"
        @total_users = User.all.size
        @weekly_user_goal = (@total_users.to_f * 0.25).to_i #25 percent goal
        @weekly_active_user_goal = (@total_users.to_f * 0.5).to_i
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
