class CreateVerses < ActiveRecord::Migration[7.2]
  def change
    create_table :verses do |t|
      t.references :book, null: false, foreign_key: true
      t.integer :chapter, null: false
      t.integer :verse, null: false
      t.text :text, null: false

      t.timestamps
    end

    add_index :verses, [ :book_id, :chapter ]
    add_index :verses, :text
  end
end
