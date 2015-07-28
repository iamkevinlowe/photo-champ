class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.references :challenger
      t.references :challenged
      t.integer :votes_challenger
      t.integer :votes_challenged
      t.integer :length

      t.timestamps null: false
    end
  end
end
