class AddActiveUsersToWeeklyDatum < ActiveRecord::Migration
  def change
    add_column :weekly_data, :active_users, :integer
    add_column :weekly_data, :user_churn, :integer
  end
end
