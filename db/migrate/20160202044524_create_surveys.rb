class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.string :name
      t.integer :credits
      t.integer :surveys_completed
      t.integer :all_credits_earned
      t.integer :avg_time_to_complete
      t.datetime :survey_added

      t.timestamps
    end
  end
end
