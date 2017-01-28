class Recorder < ApplicationRecord
  has_many :options
  accepts_nested_attributes_for :options, allow_destroy: true
  validates :title, presence: true,
            length: { maximum: 255 }
            #uniqueness: { case_sensitive: false }
end
