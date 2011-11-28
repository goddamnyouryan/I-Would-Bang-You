class AddQuestionsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :apocalypse, :text
    add_column :users, :travel, :text
    add_column :users, :class, :text
  end

  def self.down
    remove_column :users, :class
    remove_column :users, :travel
    remove_column :users, :apocalypse
  end
end
