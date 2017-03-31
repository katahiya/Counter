class CreateRecordabilities < ActiveRecord::Migration[5.0]
  def change
    create_table :recordabilities do |t|
      t.references :recorder, foreign_key: true

      t.timestamps
    end
    add_index :recordabilities, [:recorder_id, :created_at]
  end
end
