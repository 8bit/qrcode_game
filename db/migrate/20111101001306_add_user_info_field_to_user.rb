class AddUserInfoFieldToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :user_info, :text
  end

  def self.down
    remove_column :users, :user_info
  end
end
