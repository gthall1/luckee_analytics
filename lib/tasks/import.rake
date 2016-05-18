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

task :google_analytics => :environment do | t, args | 
    require 'google/apis/analytics_v3'
    Analytics = Google::Apis::AnalyticsV3
    analytics = Analytics::AnalyticsService.new

    authorizer = Google::Auth::ServiceAccountCredentials.make_creds({json_key_io: File.open(ENV['GOOGLE_APPLICATION_CREDENTIALS']),scope: 'https://www.googleapis.com/auth/analytics.readonly'})
    authorizer.fetch_access_token!

    analytics.authorization = authorizer
    profile_id = '100625219'
    dimensions = %w(ga:date)
    
    metrics = %w(ga:sessions ga:users ga:newUsers ga:percentNewSessions
                   ga:sessionDuration ga:avgSessionDuration)

    sort = %w(ga:date)
    options = Hash.new
    options[:start] = '2016-04-01'
    options[:end] = '2016-04-29'
    result = analytics.get_ga_data("ga:#{profile_id}",
                                     options[:start],
                                     options[:end],
                                     metrics.join(','),
                                     dimensions: dimensions.join(','),
                                     sort: sort.join(','))

    p result

    data = []
    data.push(result.column_headers.map { |h| h.name })
    data.push(*result.rows)
   # print_table(data)
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

    a = WeeklyDatum.all
    a.destroy_all
    
    a = DailyDatum.all
    a.destroy_all

    a = MonthlyDatum.all
    a.destroy_all

    p "Pulling New Data...#{Time.now}"
    grab_data
    denormalize_data
    aggregate_data

end

def grab_data
     get_arrivals
     get_game_sessions
     get_users
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
