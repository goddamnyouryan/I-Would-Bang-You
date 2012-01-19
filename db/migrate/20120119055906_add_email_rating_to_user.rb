class AddEmailRatingToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :email_rating, :boolean, { :null => false, :default => true }
  end

  def self.down
    remove_column :users, :email_rating
  end
end
