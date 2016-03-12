class RepsController < ApplicationController

    def index
        @reps = User.where(user_type:"rep")
        @rep_refered_users = User.where(refered_by_type: "rep")
        @weekly_user_goal = 20
        @top_rep = @reps.order('users_refered desc').first
    end
end
