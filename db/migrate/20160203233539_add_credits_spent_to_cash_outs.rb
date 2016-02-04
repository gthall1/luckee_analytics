class AddCreditsSpentToCashOuts < ActiveRecord::Migration
  def change
    add_column :cash_outs, :credits_spent, :integer
  end
end
