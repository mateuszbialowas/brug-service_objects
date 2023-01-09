class CreateShops < ActiveRecord::Migration[7.0]
  def change
    create_table :shops do |t|
      t.string :name, null: false, index: { unique: true }
      t.belongs_to :industry, null: false, foreign_key: true

      t.timestamps
    end
  end
end
