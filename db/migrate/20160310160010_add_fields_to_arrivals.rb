class AddFieldsToArrivals < ActiveRecord::Migration
  def change
    add_column :arrivals, :refered_by_type, :string
    add_column :arrivals, :refered_by_name, :string
    add_column :arrivals, :refered_by_id, :int
    add_column :arrivals, :refered_by_code, :string
  end
end
