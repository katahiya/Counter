class Recorder < ApplicationRecord
  validates :title, presence: true,
            length: { maximum: 255 }
            #uniqueness: { case_sensitive: false }
end
