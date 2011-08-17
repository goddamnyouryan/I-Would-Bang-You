class AddDetailsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :login, :string
    add_column :users, :sex, :string
    add_column :users, :looking_for_me, :boolean
    add_column :users, :looking_for_women, :boolean
    add_column :users, :birthday, :date
    add_column :users, :zip, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
  end

  def self.down
    remove_column :users, :state
    remove_column :users, :city
    remove_column :users, :zip
    remove_column :users, :birthday
    remove_column :users, :looking_for_women
    remove_column :users, :looking_for_me
    remove_column :users, :sex
    remove_column :users, :login
  end
end
