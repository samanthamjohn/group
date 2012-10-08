class AddUuidToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :uuid, :string, limit: 36, unique: true
    add_index :posts, :uuid, unique: true
  end

  def self.down
    remove_index :posts, :uuid
    remove_column :posts, :uuid
  end
end
