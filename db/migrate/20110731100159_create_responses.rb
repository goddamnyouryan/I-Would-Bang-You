class CreateResponses < ActiveRecord::Migration
  def self.up
    create_table :responses do |t|
      t.integer :message_id
      t.integer :sender_id
      t.integer :reciever_id
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :responses
  end
end
