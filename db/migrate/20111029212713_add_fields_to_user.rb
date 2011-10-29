class AddFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :gender, :string
    add_column :users, :email, :string
    add_column :users, :location, :string
    add_column :users, :bio, :string
    add_column :users, :website, :string
    add_column :users, :work, :string
  end

  def self.down
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :gender
    remove_column :users, :email
    remove_column :users, :location
    remove_column :users, :bio
    remove_column :users, :website
    remove_column :users, :work
  end
end






