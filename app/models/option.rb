class Option < ApplicationRecord
  belongs_to :recorder, inverse_of: :options
  has_many :records, dependent: :destroy
  default_scope -> { order(:created_at) }
  validates :name, presence: true, length: { maximum: 40 }
end
