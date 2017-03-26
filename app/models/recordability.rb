class Recordability < ApplicationRecord
  belongs_to :recorder
  default_scope -> { order(created_at: :desc) }
  has_many :records, dependent: :destroy
  accepts_nested_attributes_for :records, allow_destroy: true
  validates :recorder_id, presence: :true

  def unrecordable_error
    return false if self.records.any?
    errors[:base] << "数量が全て0です"
    true
  end
end
