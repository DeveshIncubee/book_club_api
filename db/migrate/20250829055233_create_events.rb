class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.string :location
      t.datetime :starts_at
      t.datetime :ends_at
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
