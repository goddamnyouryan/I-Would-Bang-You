class RenameReceiverOnResponses < ActiveRecord::Migration
  def self.up
    rename_column :responses, :reciever_id, :receiver_id
  end

  def self.down
  end
end
