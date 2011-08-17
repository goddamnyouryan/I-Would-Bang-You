class AddOriginToResponses < ActiveRecord::Migration
  def self.up
    add_column :responses, :origin, :string, { :null => false, :default => "user" }
  end

  def self.down
    remove_column :responses, :origin
  end
end
