class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :email, null: false, index: { unique: true }
      t.belongs_to :shop, null: false, foreign_key: true

      t.timestamps
    end
  end
end
