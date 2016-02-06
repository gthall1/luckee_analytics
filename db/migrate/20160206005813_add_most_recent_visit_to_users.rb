class AddMostRecentVisitToUsers < ActiveRecord::Migration
  def change
    add_column :users, :most_recent_visit, :datetime
    add_column :users, :visits_this_month, :integer
  end
end
