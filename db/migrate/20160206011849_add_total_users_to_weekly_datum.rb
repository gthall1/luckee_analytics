class AddTotalUsersToWeeklyDatum < ActiveRecord::Migration
  def change
    add_column :weekly_data, :total_users, :integer
  end
end
