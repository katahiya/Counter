class Record < ApplicationRecord
  belongs_to :recorder
  belongs_to :option
  default_scope -> { order(created_at: :desc) }
  validates :recorder_id, presence: :true
  validates :option_id, presence: :true
end
