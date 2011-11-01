class AddExtraToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :extra, :text
  end

  def self.down
    remove_column :users, :extra
  end
end
