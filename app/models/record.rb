class Record < ApplicationRecord
  belongs_to :recorder
  default_scope -> { order(created_at: :desc) }
  validates :recorder_id, presence: :true
  validates :data, presence: :true, length: { maximum: 40 }
end
