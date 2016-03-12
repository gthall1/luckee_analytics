class User < ActiveRecord::Base
    belongs_to :arrival

    def weekly_signups
        User.where(refered_by_id:self.id).where(created_at:Time.now.beginning_of_week..Time.now).size
    end
end
