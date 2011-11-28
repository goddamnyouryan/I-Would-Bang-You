class AddAFewMoreHelpfulFields < ActiveRecord::Migration
  def self.up
    add_column :users, :rating_count, :integer, {:null => false, :default => 1}
    add_column :users, :score, :integer, {:null => false, :default => 0}
    add_column :responses, :state, :string, {:null => false, :default => "unread"}
  end

  def self.down
  end
end
