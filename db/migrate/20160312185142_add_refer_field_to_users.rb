class AddReferFieldToUsers < ActiveRecord::Migration
  def change
    add_column :users, :refered_arrivals, :integer
    add_column :users, :users_refered, :integer
  end
end
