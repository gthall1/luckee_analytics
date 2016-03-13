class AddReferCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :refer_code, :string
  end
end
