class AddAvgTimePerArrivalToTotalData < ActiveRecord::Migration
  def change
    add_column :total_data, :avg_time_per_arrival, :float
  end
end
