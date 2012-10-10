class AddUuidToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :uuid, :string, limit: 36, unique: true
    add_index :users, :uuid, unique: true
  end

  def self.down
    remove_index :users, :uuid
    remove_column :users, :uuid
  end
end
