#Methods for calling luckee api
#"179 foolin@hallgriff.in Meathead_Miles"
# "129 griff@getluckee.com email_test_account"
# "6 griffhall@gmail.com gthall1"
# 199 Cbarkley94
#  ip 71.91.78.58"
# 112 Flappy_pilot_score_test
#GRIFF
#179 Meathead_Miles, 129 email_test_account, 6, gthall1, 199 cbarkley94, 112 Flappy_pilot_score_test
#ALEX
#16 amorgan, 111 Alex Morgan
#TYLER 
#93 itstcone

LUCKEE_USER_IDS = [179,129,6,199,112,111,16,93,94]

module DataProcessor
    def process_game_sessions(game_sessions)
        return false if game_sessions.blank? || game_sessions.empty?

        game_sessions.each do | g | 
            #don't duplicate data
            next if GameSession.where(id:g["id"].to_i).present?
            next if LUCKEE_USER_IDS.include? g["user_id"]
            next if g["score"] == 0 #eliminate sessions that really had no value
            GameSession.create({
                id:g["id"].to_i,
                user_id:g["user_id"].to_i,
                game_id: g["game_id"].to_i,
                credits_earned: g["credits_applied"].to_i,
                active: g["active"] == "true",
                game_session_created: g["created_at"],
                game_session_updated: g["updated_at"],
                last_score_date: g["last_score_update"],
                score: g["score"],
                arrival_id: g["arrival_id"],
                version: g["version"]
            })

        end

        return true
    end

    def process_users(users)
        return false if users.blank? || users.empty?

        users.each do | u |  

            next if LUCKEE_USER_IDS.include? u["id"]
            
            if !User.where(id:u["id"].to_i).present?
                User.create({
                    id: u["id"],
                    name: u["name"],
                    email: u["email"],
                    user_created: u["created_at"],
                    user_updated: u["updated_at"],
                    current_credits: u["credits"],
                    lifetime_credits: u["lifetime_credits"],
                    arrival_id: u["arrival_id"],
                    provider: u["provider"],
                    active: (u["created_at"] >= Time.now-1.month),
                    cashed_out_credits: u["pending_credits"],
                    refer_code: u["referral"],
                    user_type: u["user_type"].to_i == 1 ? "rep" : u["user_type"].to_i == 2 ? "admin" : nil
            })
            else

                User.find(u["id"]).update_attributes(
                        name: u["name"],
                        current_credits:  u["credits"],
                        lifetime_credits: u["lifetime_credits"],
                        cashed_out_credits: u["pending_credits"],
                        refer_code: u["referral"],
                        active: Arrival.where(user_id:u["id"].to_i).where(arrival_created: Time.now-1.month..Time.now).present?,
                        user_type: u["user_type"].to_i == 1 ? "rep" : u["user_type"].to_i == 2 ? "admin" : nil
                    )
            end
        end

    end

    def process_arrivals(arrivals)
        return false if arrivals.blank? || arrivals.empty?

        arrivals.each do | a | 
            next if LUCKEE_USER_IDS.include? a["user_id"]
            next if a["user_agent"] == 'Ruby'

            if !Arrival.where(id:a["id"].to_i).present?
                Arrival.create({
                    id: a["id"],
                    landing_url: a["landing_url"],
                    user_id: a["user_id"].to_i,
                    mobile: a["mobile"].to_i,
                    referer: a["referer"],
                    ip: a["ip"],
                    refered_by_id: a["referred_by"].to_i,
                    user_agent: a["user_agent"],
                    arrival_created: a["created_at"]
                })
            else
                Arrival.find(a["id"]).update_attributes(user_id: a["user_id"].to_i,refered_by_id: a["referred_by"].to_i)
            end
        end
    end

    def process_cash_outs(cash_outs)
        return false if cash_outs.blank? || cash_outs.empty?

        cash_outs.each do | c |
            next if CashOut.where(id:c["id"].to_i).present? 
            next if LUCKEE_USER_IDS.include? c["user_id"].to_i

            CashOut.create({
                id: c["id"],
                user_id: c["user_id"],
                cash: c["cash"],
                cash_out_date: c["created_at"],
                cash_out_type: c["cashout_type"] == 0 ? "Venmo" : "Paypal" ,
                cashout_username: c["paypal"].blank? ? c["venmo"] : c["paypal"] ,
                arrival_id:c["arrival_id"],
                credits_spent: c["credits"]
            })
        end
    end


    def process_user_surveys(user_surveys)
        return false if user_surveys.blank? || user_surveys.empty?

        user_surveys.each do | s |
            next if UserSurvey.where(id:s["id"].to_i).present? 
            next if LUCKEE_USER_IDS.include? s["user_id"]

            UserSurvey.create({
                id: s["id"],
                user_id: s["user_id"].to_i,
                survey_id: s["survey_id"],
                complete: s["complete"],
                survey_completed_at: s["updated_at"],
                survey_taken_at: s["created_at"]
            })
        end
    end   

    def process_games(games)
        return false if games.blank? || games.empty?

        games.each do | g |
            next if Game.where(id:g["id"].to_i).present? 

            Game.create({
                id: g["id"],
                name: g["name"],
                slug: g["slug"],
                game_added: g["created_at"],
                device_type: g["device_type"],
                sort_order: g["sort_order"]
            })
        end
    end

    def process_surveys(surveys)
        return false if surveys.blank? || surveys.empty?

        surveys.each do | s |
            next if Survey.where(id:s["id"].to_i).present? 

            Survey.create({
                id: s["id"],
                name: s["name"],
                credits: s["credits"],
                survey_added: s["created_at"]
            })
        end
    end 

    def denormalize_arrivals
        p "Denormalizing arrivals and performing calculations"
        # if Rails.env.development?
        #     last_batch_date = Arrival.where("created_at <= ?", Arrival.last.created_at - 2.minutes).last.created_at
        #     arrivals = Arrival.where("created_at >= ?", last_batch_date)
        # else
            arrivals = Arrival.where("created_at >= ?", Time.now - 23.hours)
       # end

        arrivals.each do | a | 
            arrival = a
            begin 
                user_agent = UserAgent.parse(a.user_agent)
                arrival.browser = user_agent.browser
                arrival.platform = user_agent.platform
            rescue => e 
                p "ERROR ON USER AGNET SUTFF #{e}" 
            end
            game_sessions = GameSession.where(arrival_id:a.id)
            if !game_sessions.blank?
                arrival.credits_earned = game_sessions.map{|ga| ga.credits_earned }.sum
                arrival.games_played = game_sessions.size
                arrival.time_played = game_sessions.map{|ga| 
                    if ga.game_session_updated.nil?
                        0
                    else
                        time = ga.game_session_updated - ga.game_session_created  unless ga.game_session_updated.nil?
                        time = 0 if time > 2000 #just too long, lets say somehting bugged
                        time.to_i
                    end
                }.sum
            else
                arrival.credits_earned = 0
                arrival.games_played = 0
                arrival.time_played = 0               
            end
            surveys_taken = UserSurvey.where(arrival_id:a.id)

            if !surveys_taken.blank? 
                arrival.surveys_taken = surveys_taken.size
            end
            cash_outs = CashOut.where(arrival_id:arrival.id)

            if !cash_outs.blank?
                arrival.cash_out_count = cash_outs.size
                arrival.cash_out_value = cash_outs.map{ |c | c.cash }.sum
            end

            if !arrival.landing_url.blank? && arrival.landing_url.include?("/invite/")
                code = arrival.landing_url.split('/').last
                refered_user_from_code = User.where(refer_code:code).first
                if refered_user_from_code
                    arrival.refered_by_id = refered_user_from_code.id
                end
            end
            if !arrival.landing_url.blank? && arrival.landing_url.include?("/r-")
                code = arrival.landing_url.split('-').last
                refered_user_from_code = User.where(refer_code:code).first
                if refered_user_from_code
                    arrival.refered_by_id = refered_user_from_code.id
                end
            end
            if !arrival.refered_by_id.blank? && arrival.refered_by_id != 0
                refer_user = User.where(id:arrival.refered_by_id).first
                arrival.refered_by_name = !refer_user.nil? ? refer_user.name : arrival.refered_by_id.to_s
                arrival.refered_by_code = arrival.landing_url
                arrival.refered_by_type = refer_user.nil? ? "admin" : refer_user.user_type
                arrival.save
                if arrival.user_id.blank?
                    future_arrival_with_user = Arrival.where.not(user_id:nil).where(ip:arrival.ip).where("created_at > ?",arrival.arrival_created).last
                    if !future_arrival_with_user.blank?
                        future_arrival_with_user.refered_by_name = arrival.refered_by_name
                        future_arrival_with_user.refered_by_code = arrival.refered_by_code
                        future_arrival_with_user.refered_by_type = arrival.refered_by_type
                        future_arrival_with_user.save
                    end
                end
            end
            if arrival.user_id
                a_user = User.where(id:a.user_id).first
                if a_user
                    arrival.user_name = a_user.name
                   # arrival.user_provider = a_user.provider
                end
            end
            arrival.save
        end

    end

    def denormalize_users
        p "Denormalizing users and performing calculations"
    

        User.find_each do | u | 
            user_arrivals = Arrival.where(user_id: u.id).order('arrival_created asc')

            if !user_arrivals.blank?
                u.visits_to_site = user_arrivals.size
                u.most_recent_device = user_arrivals.last.platform
                u.most_recent_visit = user_arrivals.last.arrival_created
                u.visits_this_month = user_arrivals.where(:arrival_created => Time.now.beginning_of_month..Time.now).size
            end

            if !u.arrival_id.blank?
                origin_arrival = Arrival.where(id:u.arrival_id).first
                if !origin_arrival.blank?
                    if origin_arrival.user_id.blank?
                        origin_arrival.user_id = u.id
                    end
                    #this is case if they arrive and then set up home screen whihc creates new arrival from new session
                    if origin_arrival.ip && Arrival.where(ip:origin_arrival.ip,arrival_created: origin_arrival.arrival_created - 1.hour..origin_arrival.arrival_created + 1.minute).first.id != origin_arrival.id
                        origin_arrival = Arrival.where(ip:origin_arrival.ip,arrival_created: origin_arrival.arrival_created - 1.hour..origin_arrival.arrival_created + 1.minute).first
                        u.arrival_id = origin_arrival.id
                        origin_arrival.user_id = u.id
                    end
                    if !origin_arrival.refered_by_id.blank? && origin_arrival.refered_by_id != 0
                        #refered_by_type: nil, refered_by_name: nil, refered_by_id: nil, refered_by_code: nil, user_type: nil
                        u.refered_by_name = origin_arrival.refered_by_name
                        u.refered_by_id = origin_arrival.refered_by_id
                        u.refered_by_code = origin_arrival.refered_by_code
                        u.refered_by_type = origin_arrival.refered_by_type
                    end
                    origin_arrival.signup = true
                    origin_arrival.save
                    if u.origin_country.blank? 
                        country_name = $geo.country(origin_arrival.ip).country_name
                        sleep 0.25 #for not hammering geo methods
                        u.origin_country = country_name
                        country_name = nil
                    end
                    u.origin_refer = origin_arrival.referer
                    u.origin_device = origin_arrival.platform
                end
            end

            game_sessions = GameSession.where(user_id:u.id)

            if !game_sessions.blank?
                u.credits_from_games = game_sessions.map{|ga| ga.credits_earned }.sum
                u.game_sessions = game_sessions.size
                u.time_spent_playing = game_sessions.map{|ga| 
                    if ga.game_session_updated.blank?
                        0
                    else
                        time = ga.game_session_updated - ga.game_session_created  
                        time = 0 if time > 2000 #just too long, lets say somehting bugged
                        time.to_i
                    end
                }.sum
                u.unique_games_played = game_sessions.map{|g| g.game_id}.uniq.size
                if !u.lifetime_credits.blank? && u.time_spent_playing > 0 
                   
                    u.credits_per_minute = u.credits_from_games.to_f/(u.time_spent_playing.to_f/60.to_f)
                    u.credits_per_game = u.credits_from_games.to_f/game_sessions.size.to_f
                else
                    u.credits_per_game = 0
                    u.credits_per_minute = 0
                end
            else
                u.credits_per_game = 0
                u.credits_per_minute = 0      
            end 

            cash_outs = CashOut.where(user_id:u.id)

            if !cash_outs.blank?
                u.cash_outs = cash_outs.size
                u.cash_out_value = cash_outs.map{|co| co.cash }.sum
                u.cashed_out_credits = cash_outs.map{|co| co.credits_spent }.sum 
                u.cost_per_minute = u.cash_out_value.to_f/(u.time_spent_playing.to_f/60.to_f)
                u.cost_per_game = u.cash_out_value.to_f/game_sessions.size.to_f
            else
                u.cash_outs = 0
                u.cash_out_value = 0
                u.cashed_out_credits = 0
                u.cost_per_minute = 0
                u.cost_per_game = 0
            end

            surveys = UserSurvey.where(user_id:u.id,complete:true)

            if !surveys.blank?
                u.surveys_complete = surveys.size
                u.credits_from_surveys = surveys.map{|s| Survey.where(id:s.survey_id).first.credits }.sum
            else
                u.surveys_complete = 0
                u.credits_from_surveys = 0
            end

            u.refered_arrivals = Arrival.where(refered_by_id:u.id).size
            u.users_refered = User.where(refered_by_id: u.id).size
            u.save
        end

    end

    def denormalize_game_sessions
        p "Denormalizing game sessions and performing calculations"


         GameSession.where("created_at >= ?", Time.now - 23.hours).find_each do | gs| 

            arrival = Arrival.where(id:gs.arrival_id).first
            if !arrival.blank?
                gs.browser = arrival.browser
                gs.platform = arrival.platform
            end
            user = User.where(id:gs.user_id).first

            if !user.blank?
                gs.user_name = user.name
                gs.user_created = user.user_created
                gs.user_provider = user.provider
            end
            
            if gs.game_session_updated
                gs.time_played = gs.game_session_updated - gs.game_session_created
            else
                gs.time_played = 0
            end

            if gs.credits_earned != 0
                gs.credits_per_minute = gs.credits_earned/(gs.time_played.to_f/60.to_f)
            else
                gs.credits_per_minute = 0
            end

            gs.save
        end
    end

    def denormalize_games 
        p "Denormalizing games and performing calculations"
        games = Game.where.not(device_type:nil)

        games.each do | game|
            g = game 
            #game_sessions = GameSession.where(game_id:g.id)
            if !GameSession.where(game_id:g.id).blank?
                g.total_credits_earned =  GameSession.where(game_id:g.id).sum(:credits_earned)
                g.total_time_spent_on_game = GameSession.where(game_id:g.id).map{|ga| 
                    time = ga.game_session_updated - ga.game_session_created  
                    time = 0 if time > 2000 #just too long, lets say somehting bugged
                    time.to_i
                }.sum
                g.total_users_who_played = GameSession.where(game_id:g.id).group(:user_id).size.size
                g.total_games_played = GameSession.where(game_id:g.id).count
                g.time_per_game = g.total_time_spent_on_game.to_f/g.total_games_played.to_f
                g.avg_score = GameSession.where(game_id:g.id).average(:score).to_f
                g.credits_per_minute= g.total_credits_earned/(g.total_time_spent_on_game.to_f/60.to_f)
                g.credits_per_game = g.total_credits_earned.to_f/g.total_games_played.to_f
                g.save
            end

        end
    end

    def denormalize_surveys
        p "Denormalizing surveys and performing calculations"
        Survey.find_each do | s |
            user_surveys = UserSurvey.where(survey_id: s.id,complete: true)
            if !user_surveys.blank? && !user_surveys.empty?
                s.surveys_completed = user_surveys.size
                s.all_credits_earned = user_surveys.map{|us| 
                                       c = us.credits_earned
                                       c = 0 if us.credits_earned.nil?
                                       c
                                    }.sum
                # total_time = user_surveys.map{|us| 
                #         time = us.survey_completed_at - us.survey_taken_at 
                #         time
                #     }.sum
                #     p (s.surveys_completed.to_f/total_time.to_f)
                # s.avg_time_to_complete = (s.surveys_completed.to_f/total_time.to_f)
                # p s.avg_time_to_complete
            end
            s.save
        end

    end

    def denormalize_cashouts   
    p "Denormalizing cashouts and performing calculations"
 

        CashOut.find_each do |co|
            u = User.where(id:co.user_id).first

            if !u.blank?
                co.user_credits_per_minute = u.credits_per_minute
                co.user_time_playing = u.time_spent_playing
                co.user_credits_per_game = u.credits_per_game
                co.user_email = u.email
                co.user_created = u.user_created
            end

            arrival = Arrival.where(id: co.arrival_id).first

            if !arrival.blank?
                co.device = arrival.platform
                co.referal = arrival.referer
            end
            co.save
        end

    end 

    def denormalize_user_surveys
        p "Denormalizing user surveys and performing calculations"


         UserSurvey.where(complete:true).find_each do |us|
            u = User.where(id:us.user_id).first
            if !u.blank?
                us.user_created_at = u.user_created
            end

            a = Arrival.where(id:us.arrival_id).first
            if !a.blank?
                us.arrival_created_at = a.arrival_created
            end

            s = Survey.where(id:us.survey_id).first

            if !s.blank? 
                us.survey_name = s.name
                us.credits_earned = s.credits
            end

            us.save
        end

    end

    def aggregate_daily_data

        start_date = User.first.user_created.beginning_of_day
        end_of_day = start_date.end_of_day 

        if DailyDatum.count > 0
            #go back a few days just to make sure we got everything
            start_date = (DailyDatum.last.date-3.days).beginning_of_day
            end_of_day = start_date.end_of_day  
            DailyDatum.where(:date => start_date..Time.now).destroy_all
        end

        loop do 
            break if start_date > Time.now
            p "Loading data for #{start_date}"
            game_sessions = GameSession.where(:game_session_created =>start_date..end_of_day)
            cash_outs = CashOut.where(:cash_out_date =>start_date..end_of_day)
            arrivals = Arrival.where(:arrival_created =>start_date..end_of_day)

            credits_earned = game_sessions.map{|ga| ga.credits_earned }.sum
            #Time spent is in seconds
            time_spent_playing = game_sessions.map{|ga| 
                                            time = ga.game_session_updated - ga.game_session_created  
                                            time = 0 if time > 2000 #just too long, lets say somehting bugged
                                            time.to_i
                                        }.sum

            dau =  arrivals.where.not(user_id:nil).map{|a| a.user_id }.uniq
            
            prev_dau = Arrival.where.not(user_id:nil).where(:arrival_created =>(start_date-1.day).beginning_of_day..(start_date-1.day).end_of_day).map{|a| a.user_id }.uniq
         

            DailyDatum.create({
                    date:start_date,
                    arrivals: arrivals.size, 
                    sign_ups: User.where(:user_created => start_date..end_of_day).size, 
                    cash_outs: cash_outs.size, 
                    active_users: dau.size,
                    user_churn: (prev_dau - dau).size,
                    surveys: UserSurvey.where(:survey_completed_at =>start_date..end_of_day).size, 
                    games_played: game_sessions.size, 
                    credits_earned: credits_earned, 
                    cash_payed_out: cash_outs.map{|co| co.cash }.sum, 
                    time_spent_playing: time_spent_playing, 
                    mobile_arrivals: arrivals.where(mobile:1).size, 
                    desktop_arrivals: arrivals.where(mobile:0).size, 
                    unique_users: arrivals.map{|a| a.user_id }.uniq.size, 
                    credits_per_minute: credits_earned.to_f/(time_spent_playing.to_f/60.to_f) 
                })


            start_date = (start_date + 1.day).beginning_of_day
            end_of_day = start_date.end_of_day 
        end
    end

    def aggregate_weekly_data

        start_week = User.first.user_created.beginning_of_week
        end_of_week = start_week.end_of_week 

        if WeeklyDatum.count > 0
            #go back a week just to make sure we got everything
            start_week = (WeeklyDatum.last.date-1.week).beginning_of_week
            end_of_week = start_week.end_of_week  
            a = WeeklyDatum.where(:date => start_week..Time.now).destroy_all
        end

        loop do 
            break if start_week > Time.now
            p "Loading data for #{start_week}"
            game_sessions = GameSession.where(:game_session_created =>start_week..end_of_week)
            cash_outs = CashOut.where(:cash_out_date =>start_week..end_of_week)
            arrivals = Arrival.where(:arrival_created =>start_week..end_of_week)

            credits_earned = game_sessions.map{|ga| ga.credits_earned }.sum
            #Time spent is in seconds
            time_spent_playing = game_sessions.map{|ga| 
                                            time = ga.game_session_updated - ga.game_session_created  
                                            time = 0 if time > 2000 #just too long, lets say somehting bugged
                                            time.to_i
                                        }.sum
            wau =  arrivals.where.not(user_id:nil).map{|a| a.user_id }.uniq
            
            prev_wau = Arrival.where.not(user_id:nil).where(:arrival_created =>(start_week-1.week).beginning_of_week..(start_week-1.week).end_of_week).map{|a| a.user_id }.uniq
            
            WeeklyDatum.create({
                    date:start_week,
                    arrivals: arrivals.size, 
                    sign_ups: User.where(:user_created => start_week..end_of_week).size, 
                    cash_outs: cash_outs.size, 
                    active_users: wau.size,
                    user_churn: (prev_wau - wau).size,
                    surveys: UserSurvey.where(:survey_taken_at =>start_week..end_of_week).size, 
                    games_played: game_sessions.size, 
                    credits_earned: credits_earned, 
                    cash_payed_out: cash_outs.map{|co| co.cash }.sum, 
                    time_spent_playing: time_spent_playing, 
                    mobile_arrivals: arrivals.where(mobile:1).size, 
                    desktop_arrivals: arrivals.where(mobile:0).size, 
                    unique_users: arrivals.map{|a| a.user_id }.uniq.size, 
                    credits_per_minute: credits_earned.to_f/(time_spent_playing.to_f/60.to_f),
                    total_users: User.where(:user_created => User.first.user_created..end_of_week).size
                })


            start_week = (start_week + 1.week).beginning_of_week
            end_of_week = start_week.end_of_week 
        end
    end 

    def aggregate_monthly_data

        start_month = User.first.user_created.beginning_of_month
        end_of_month = start_month.end_of_month

        if MonthlyDatum.count > 0
            #go back a month just to make sure we got everything
            start_month = (MonthlyDatum.last.date-1.month).beginning_of_month
            end_of_month = start_month.end_of_month  
            a = MonthlyDatum.where(:date => start_month..Time.now)
            a.destroy_all
        end

        loop do 
            break if start_month > Time.now
            p "Loading data for #{start_month}"
            game_sessions = GameSession.where(:game_session_created =>start_month..end_of_month)
            cash_outs = CashOut.where(:cash_out_date =>start_month..end_of_month)
            arrivals = Arrival.where(:arrival_created =>start_month..end_of_month)

            credits_earned = game_sessions.map{|ga| ga.credits_earned }.sum
            #Time spent is in seconds
            time_spent_playing = game_sessions.map{|ga| 
                                            time = ga.game_session_updated - ga.game_session_created  
                                            time = 0 if time > 2000 #just too long, lets say somehting bugged
                                            time.to_i
                                        }.sum
            mau =  arrivals.where.not(user_id:nil).map{|a| a.user_id }.uniq
            
            prev_mau = Arrival.where.not(user_id:nil).where(:arrival_created =>(start_month-1.month).beginning_of_month..(start_month-1.month).end_of_month).map{|a| a.user_id }.uniq
            
            MonthlyDatum.create({
                    date:start_month,
                    arrivals: arrivals.size, 
                    sign_ups: User.where(:user_created => start_month..end_of_month).size, 
                    cash_outs: cash_outs.size, 
                    active_users: mau.size,
                    user_churn: (prev_mau - mau).size,
                    surveys: UserSurvey.where(:survey_completed_at =>start_month..end_of_month).size, 
                    games_played: game_sessions.size, 
                    credits_earned: credits_earned, 
                    cash_payed_out: cash_outs.map{|co| co.cash }.sum, 
                    time_spent_playing: time_spent_playing, 
                    mobile_arrivals: arrivals.where(mobile:1).size, 
                    desktop_arrivals: arrivals.where(mobile:0).size, 
                    unique_users: arrivals.map{|a| a.user_id }.uniq.size, 
                    credits_per_minute: credits_earned.to_f/(time_spent_playing.to_f/60.to_f) 
                })


            start_month = (start_month + 1.month).beginning_of_month
            end_of_month = start_month.end_of_month 
        end
    end

    def aggregate_total_data

        TotalDatum.destroy_all

        p "Loading Totals"
       # game_sessions = GameSession.all
        #cash_outs = CashOut.all
        #arrivals = Arrival.all

        credits_earned = GameSession.sum(:credits_earned)
        #Time spent is in seconds
        # time_spent_playing = game_sessions.map{|ga| 
        #                                 time = ga.game_session_updated - ga.game_session_created  
        #                                 (time = 0 if time > 2000) #just too long, lets say somehting bugged
        #                                 time.to_i
        #                             }.sum

        time_spent_playing = MonthlyDatum.sum(:time_spent_playing)
       # cash_payed = cash_outs.map{|co| co.cash }.sum
        cash_payed = CashOut.sum(:cash)
        games_played = GameSession.count
        arrivals = Arrival.count
        b = TotalDatum.create({
            arrivals: arrivals, 
            users: User.count, 
            cash_outs: CashOut.count, 
            surveys: UserSurvey.count, 
            games_played: games_played, 
            credits_earned: credits_earned, 
            cash_payed_out: cash_payed, 
            time_spent_playing: time_spent_playing, 
            mobile_arrivals: Arrival.where(mobile:1).size, 
            games_per_arrival: games_played.to_f/arrivals.to_f, 
            desktop_arrivals: Arrival.where(mobile:0).size, 
            credits_per_minute: credits_earned.to_f/(time_spent_playing.to_f/60.to_f),
            cost_per_minute:  cash_payed/(time_spent_playing.to_f/60.to_f),
            avg_time_per_arrival: (time_spent_playing.to_f/60.to_f)/arrivals.to_f
        })

    end          
end

    