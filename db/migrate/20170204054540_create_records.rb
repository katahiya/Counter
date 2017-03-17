class CreateRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :records do |t|
      t.references :recordability, foreign_key: true
      t.references :option, foreign_key: true

      t.timestamps
    end
    add_index :records, [:recordability_id, :created_at]
  end
end
