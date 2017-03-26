class Recordability < ApplicationRecord
  belongs_to :recorder
  default_scope -> { order(created_at: :desc) }
  has_many :records, dependent: :destroy
  accepts_nested_attributes_for :records, reject_if: :reject_record,
                                          allow_destroy: true
  validates :recorder_id, presence: :true

  def unrecordable_error
    errors[:base] << "数量が全て0です"
  end

  def reject_record(attr)
    attr.merge!(_destroy: true) if attr[:count] == '0' && !attr[:id].nil?
    attr[:count] == '0' && attr[:id].nil?
  end
end
