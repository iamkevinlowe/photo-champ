class AddCompleteToChallenge < ActiveRecord::Migration
  def change
    add_column :challenges, :complete, :boolean
  end
end
