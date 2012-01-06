class AddingIndexesToIDsandForeignKeys < ActiveRecord::Migration
  def self.up
    add_index :hides, :id
    add_index :hides, :user_id
    add_index :hides, :hidden_id
    add_index :messages, :id
    add_index :messages, :sender_id
    add_index :messages, :receiver_id
    add_index :messages, :state
    add_index :photos, :id
    add_index :photos, :user_id
    add_index :questions, :id
    add_index :questions, :user_id
    add_index :questions, :kind
    add_index :ratings, :id
    add_index :ratings, :user_id
    add_index :ratings, :mate_id
    add_index :ratings, :status
    add_index :responses, :id
    add_index :responses, :message_id
    add_index :responses, :sender_id
    add_index :responses, :receiver_id
    add_index :responses, :state
    add_index :responses, :origin
    add_index :users, :id
    add_index :users, :zip
    add_index :users, :latitude
    add_index :users, :longitude
  end

  def self.down
  end
end
