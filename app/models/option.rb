class Option < ApplicationRecord
  belongs_to :recorder, inverse_of: :options
  has_many :records, dependent: :destroy
  default_scope -> { order(:created_at) }
  validates :name, length: { maximum: 40 },
                   uniqueness: { scope: [:recorder_id] }
end
