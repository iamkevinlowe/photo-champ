class FixChallengeColumnName < ActiveRecord::Migration
  def change
    rename_column :challenges, :complete, :completed
  end
end
