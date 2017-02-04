class CreateRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :records do |t|
      t.string :data
      t.references :recorder, foreign_key: true

      t.timestamps
    end
    add_index :records, [:recorder_id, :created_at]
  end
end
