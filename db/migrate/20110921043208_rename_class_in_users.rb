class RenameClassInUsers < ActiveRecord::Migration
  def self.up
    rename_column :users, :class, :favorite_class
  end

  def self.down
  end
end
