class CleanUpQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :kind, :string
    remove_column :users, :apocalypse
    remove_column :users, :travel
    remove_column :users, :favorite_class
  end

  def self.down
  end
end
