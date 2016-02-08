#API KEY Ibvvse7ZX1CKzthJ2xB2_Q
#getluckee.com/api/v1/Ibvvse7ZX1CKzthJ2xB2_Q/user_surveys?start=1&end=100
require "#{Rails.root}/lib/import_helper.rb"

include ImportHelper

BATCH_SIZE = 300

task :import_data => :environment do |t,args|
    grab_data
    denormalize_data
    aggregate_data
end

task :repull_all_data => :environment do |t,args|

    p "Wiping all data...#{Time.now}"
    a = GameSession.all
    a.destroy_all

    a = User.all
    a.destroy_all

    a = Arrival.all
    a.destroy_all

    a = CashOut.all
    a.destroy_all

    a = UserSurvey.all
    a.destroy_all

    a = Survey.all
    a.destroy_all

    a = Game.all
    a.destroy_all

    p "Pulling New Data...#{Time.now}"
    grab_data
    denormalize_data
    aggregate_data

end

def grab_data
     get_game_sessions
     get_users
     get_arrivals
     get_cash_outs
     get_user_surveys
     get_surveys
     get_games 
end

def denormalize_data
    denormalize_arrivals
    denormalize_users
    denormalize_game_sessions
    denormalize_games
    denormalize_surveys
    denormalize_cashouts
    denormalize_user_surveys 
end

def aggregate_data
    aggregate_daily_data
    aggregate_weekly_data
    aggregate_monthly_data
    aggregate_total_data
end
