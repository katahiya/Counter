class Recorder < ApplicationRecord
  belongs_to :user
  default_scope -> { order(updated_at: :desc) }
  has_many :options, dependent: :destroy, inverse_of: :recorder
  has_many :recordabilities, dependent: :destroy
  accepts_nested_attributes_for :options, allow_destroy: true
  accepts_nested_attributes_for :recordabilities, allow_destroy: true
  validates :user_id, presence: true
  validates :title, presence: true,
            length: { maximum: 255 }
            #uniqueness: { case_sensitive: false }
end
