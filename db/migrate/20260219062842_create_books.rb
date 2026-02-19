class CreateBooks < ActiveRecord::Migration[7.2]
  def change
    create_table :books do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.integer :testament, null: false
      t.integer :position, null: false
      t.integer :total_chapters, null: false

      t.timestamps
    end
    
    add_index :books, :slug, unique: true
    add_index :books, :position
  end
end
