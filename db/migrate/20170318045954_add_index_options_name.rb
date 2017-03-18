class AddIndexOptionsName < ActiveRecord::Migration[5.0]
  def change
    add_index :options, [:name, :recorder_id], unique: true
  end
end
