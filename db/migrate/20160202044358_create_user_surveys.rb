class CreateUserSurveys < ActiveRecord::Migration
  def change
    create_table :user_surveys do |t|
      t.integer :survey_id
      t.integer :user_id
      t.integer :arrival_id
      t.integer :arrival_created_at
      t.string :referer
      t.string :platform
      t.string :survey_name
      t.datetime :user_created_at
      t.datetime :survey_taken_at
      t.datetime :survey_completed_at
      t.boolean :complete
      t.integer :credits_earned
      t.timestamps
    end
  end
end
