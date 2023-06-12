class CreateBookmarks < ActiveRecord::Migration[7.0]
  def change
    create_table :bookmarks do |t|
      t.string :title
      t.text :description
      t.string :url
      t.integer :indentifier_in_source
      t.datetime :created_in_source_at
      t.datetime :updated_in_source_at

      t.timestamps
    end
  end
end
