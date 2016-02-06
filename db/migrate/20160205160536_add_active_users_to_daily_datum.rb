class AddActiveUsersToDailyDatum < ActiveRecord::Migration
  def change
    add_column :daily_data, :active_users, :integer
    add_column :daily_data, :user_churn, :integer
  end
end
