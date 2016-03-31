class AddOriginCountryToUsers < ActiveRecord::Migration
  def change
    add_column :users, :origin_country, :string
  end
end
