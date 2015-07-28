class AddEndsAtToChallenge < ActiveRecord::Migration
  def change
    add_column :challenges, :ends_at, :datetime
  end
end
