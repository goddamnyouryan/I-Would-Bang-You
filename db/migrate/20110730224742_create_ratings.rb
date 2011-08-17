class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.integer :user_id
      t.integer :mate_id
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :ratings
  end
end
