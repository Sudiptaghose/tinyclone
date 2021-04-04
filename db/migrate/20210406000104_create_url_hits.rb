class CreateUrlHits < ActiveRecord::Migration[6.1]
  def change
    create_table :url_hits do |t|
      t.references :long_url, null: false, foreign_key: true
      t.string :ip_address
      t.timestamps
    end
  end
end
