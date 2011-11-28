class CreateHides < ActiveRecord::Migration
  def self.up
    create_table :hides do |t|
      t.integer :user_id
      t.integer :hidden_id

      t.timestamps
    end
  end

  def self.down
    drop_table :hides
  end
end
