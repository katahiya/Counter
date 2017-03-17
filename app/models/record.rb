class Record < ApplicationRecord
  belongs_to :recordability
  belongs_to :option
  default_scope -> { order(:created_at) }
  validates :recordability_id, presence: :true
  validates :option_id, presence: :true
  validates :count, numericality: { only_integer: true, greater_than: 0 }
end
