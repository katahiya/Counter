class Recordability < ApplicationRecord
  belongs_to :recorder
  default_scope -> { order(created_at: :desc) }
  has_many :records, dependent: :destroy
  accepts_nested_attributes_for :records, allow_destroy: true
  validates :recorder_id, presence: :true
end
