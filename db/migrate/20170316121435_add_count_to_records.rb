class AddCountToRecords < ActiveRecord::Migration[5.0]
  def change
    add_column :records, :count, :integer
  end
end
