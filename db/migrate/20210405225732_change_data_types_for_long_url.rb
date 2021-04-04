class ChangeDataTypesForLongUrl < ActiveRecord::Migration[6.1]
  def up
    change_column :long_urls, :token, :string, :limit => 5
    remove_column :long_urls, :md5hash
    add_column :long_urls, :md5hash, :binary, :limit => 16
    add_index :long_urls, :token, unique: true
    add_index :long_urls, :md5hash, unique: true
  end
  def down
    change_column :long_urls, :token, :string, :limit => 9
    remove_column :long_urls, :md5hash
    add_column :long_urls, :md5hash, :string, :limit => 24
    remove_index :long_urls, :token, if_exists: true
    add_index :long_urls, :md5hash, unique: true
  end
end
