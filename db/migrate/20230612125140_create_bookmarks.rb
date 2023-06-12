class CreateBookmarks < ActiveRecord::Migration[7.0]
  def change
    create_table :bookmarks do |t|
      t.text :title
      t.text :description
      t.text :url
      t.integer :identifier_in_source
      t.datetime :created_in_source_at
      t.datetime :updated_in_source_at

      t.timestamps
    end
  end
end
