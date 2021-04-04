class CreateLongUrls < ActiveRecord::Migration[6.1]
  def change
    create_table :long_urls do |t|
      t.string :url
      t.string :token, limit: 9
      t.string :md5hash, limit: 24

      t.timestamps
    end
    add_index :long_urls, :md5hash, unique: true
  end
end
