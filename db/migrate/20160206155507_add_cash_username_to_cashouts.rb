class AddCashUsernameToCashouts < ActiveRecord::Migration
  def change
        add_column :cash_outs, :cashout_username, :string
  end
end
