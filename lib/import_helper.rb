require "#{Rails.root}/lib/data_processor.rb"
require "#{Rails.root}/lib/api_module.rb"

include ApiModule
include DataProcessor

module ImportHelper
    def get_game_sessions(args={})
        p "Getting Game Sessions"
        process_loop({slug:"gs"})
    end

    #always start at 1 to update stats
    def get_users(args={})
        p "Getting Users"
        process_loop({slug:"u",start_id:1})
    end

    def get_arrivals(args={})
        p "Getting Arrivals"
        process_loop({slug:"a"})
    end

    def get_cash_outs(args={})
        p "Getting Cash Outs"
        process_loop({slug:"co"})
    end

    def get_user_surveys(args={})
        p "Getting User Surveys"
        process_loop({slug:"us"})
    end

    def get_surveys(args={})
        p "Getting Surveys"
        process_loop({slug:"s"})
    end

    def get_games(args={})
        p "Getting Games"
        process_loop({slug:"g"})
    end


    def process_loop(args={})
        slug = args[:slug]
        begin 
            i = 1
            batch_start = args[:start_id] || get_last_for_type(slug)
            loop do 
                p "Starting batch #{i}...#{batch_start} - #{batch_start+BATCH_SIZE}"
                break unless process_call({start_id: batch_start,end_id:batch_start+BATCH_SIZE,slug: slug})
                batch_start += (BATCH_SIZE + 1)
                i += 1
            end
        rescue => e
            p "Error with sessions #{e}"
        end  
    end

    def process_call(args={})
        start_id = args[:start_id]
        end_id = args[:end_id]
        slug = args[:slug]

        case slug 
            when "gs"
                return process_game_sessions(get_game_session_batch({start_id:start_id,end_id:end_id}))
            when "u"
                return process_users(get_user_batch({start_id:start_id,end_id:end_id}))
            when "a"
                return process_arrivals(get_arrival_batch({start_id:start_id,end_id:end_id}))
            when "co"
                return process_cash_outs(get_cash_out_batch({start_id:start_id,end_id:end_id}))  
            when "us"
                return process_user_surveys(get_user_survey_batch({start_id:start_id,end_id:end_id}))
            when "s"
                return process_surveys(get_survey_batch({start_id:start_id,end_id:end_id})) 
            when "g"
                return process_games(get_game_batch({start_id:start_id,end_id:end_id}))                                                 
            else 
                return false
        end
    end

    def get_last_for_type(slug)
        case slug
            when "gs"
                #game can be updated with more score/credit data, so try and nix ones that could be out of dates
                stale_games = GameSession.where(:game_session_created => Time.now-3.days..Time.now)
                stale_games.destroy_all                
                return GameSession.last.id unless GameSession.last.blank?
            when "u"
                return User.last.id unless User.last.blank?
            when "a"
                #arrivals can be updated with user id so delete ones that may not have bene at time of pull
                stale_arrivals = Arrival.where(:arrival_created => Time.now-1.day..Time.now)
                stale_arrivals.destroy_all
                return Arrival.last.id unless Arrival.last.blank?
            when "co"
                return CashOut.last.id unless CashOut.last.blank?
            when "us"
                return UserSurvey.last.id unless UserSurvey.last.blank?
            when "s"
                return Survey.last.id unless Survey.last.blank?  
            when "g"
                return Game.last.id unless Game.last.blank?                       
            else 
                return 1
        end

        return 1 #if we make it here, just return 1
    end  
end

    