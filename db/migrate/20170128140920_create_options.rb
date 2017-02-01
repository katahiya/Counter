class CreateOptions < ActiveRecord::Migration[5.0]
  def change
    create_table :options do |t|
      t.string :name
      t.references :recorder, foreign_key: true

      t.timestamps
    end
    add_index :options, [:recorder_id, :created_at]
  end
end
