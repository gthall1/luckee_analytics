#Methods for calling luckee api
module ApiModule
require "net/http"
require "uri"

    def get_request_data(uri)
          url = URI.parse(uri)
          # = Net::HTTP.new(url.host, url.port)
          response = Net::HTTP.get_response(url)

        #  http.use_ssl = true
        #  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
         # request = Net::HTTP::Get.new(url.path) 
          #response = http.request(request)  

        JSON.parse response.body
    end

    def get_game_session_batch(args={})
        get_request_data(base_uri+game_sessions_path+get_params({start_id: args[:start_id],end_id: args[:end_id]}))
    end

    def get_user_batch(args={})
        get_request_data(base_uri+users_path+get_params({start_id: args[:start_id],end_id: args[:end_id]}))
    end

    def get_arrival_batch(args={})
        get_request_data(base_uri+arrival_path+get_params({start_id: args[:start_id],end_id: args[:end_id]}))
    end

    def get_user_survey_batch(args={})
        get_request_data(base_uri+user_surveys_path+get_params({start_id: args[:start_id],end_id: args[:end_id]}))
    end

    def get_survey_batch(args={})
        get_request_data(base_uri+surveys_path+get_params({start_id: args[:start_id],end_id: args[:end_id]}))
    end

    def get_cash_out_batch(args={})
        get_request_data(base_uri+cash_out_path+get_params({start_id: args[:start_id],end_id: args[:end_id]}))
    end

    def get_game_batch(args={})
        get_request_data(base_uri+games_path+get_params({start_id: args[:start_id],end_id: args[:end_id]}))
    end

    def get_params(args={})
        "?start=#{args[:start_id]}&end=#{args[:end_id]}"
    end

    def base_uri
        "http://www.getluckee.com/api/v1/#{ENV['LUCKEE_API_KEY']}/"
    end

    def game_sessions_path
        "user_games"
    end

    def users_path
        "users"
    end

    def games_path
        "games"
    end

    def arrival_path
        "arrivals"
    end

    def surveys_path
        "surveys"
    end

    def user_surveys_path
        "user_surveys"
    end

    def cash_out_path
        "cashouts"
    end

            
end