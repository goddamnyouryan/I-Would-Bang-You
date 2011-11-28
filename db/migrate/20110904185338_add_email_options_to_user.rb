class AddEmailOptionsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :email_match, :boolean, { :null => false, :default => true }
    add_column :users, :email_message, :boolean, { :null => false, :default => true }
  end

  def self.down
    remove_column :users, :email_message
    remove_column :users, :email_match
  end
end
