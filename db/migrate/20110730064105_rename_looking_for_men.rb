class RenameLookingForMen < ActiveRecord::Migration
  def self.up
    rename_column :users, :looking_for_me, :looking_for_men
  end

  def self.down
  end
end
