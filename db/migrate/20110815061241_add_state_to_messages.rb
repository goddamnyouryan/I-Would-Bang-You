class AddStateToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :state, :string, { :null => false, :default => "unread" }
  end

  def self.down
    remove_column :messages, :state
  end
end
