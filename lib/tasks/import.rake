#API KEY Ibvvse7ZX1CKzthJ2xB2_Q
#getluckee.com/api/v1/Ibvvse7ZX1CKzthJ2xB2_Q/user_surveys?start=1&end=100
require "#{Rails.root}/lib/import_helper.rb"

include ImportHelper

BATCH_SIZE = 300

task :import_data => :environment do |t,args|
   # get_game_sessions
   # get_users
   # get_arrivals
   # get_cash_outs
    #get_user_surveys
   # get_surveys
   # get_games

end

task :denormalize_things => :environment do |t,args|
    denormalize_arrivals
    denormalize_users
    denormalize_game_sessions
    denormalize_games
    denormalize_surveys
    denormalize_cashouts
    denormalize_user_surveys
end

task :aggregate_data => :environment do |t,args|
   # aggregate_daily_data
    #aggregate_weekly_data
    aggregate_total_data
end
