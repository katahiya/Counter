class AddRecorderIdToOptions < ActiveRecord::Migration[5.0]
  def change
    add_column :options, :recorder_id, :integer
  end
end
