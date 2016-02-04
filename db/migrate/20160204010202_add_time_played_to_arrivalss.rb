class AddTimePlayedToArrivalss < ActiveRecord::Migration
  def change
    add_column :arrivals, :time_played, :integer
  end
end
