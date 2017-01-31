class Option < ApplicationRecord
  belongs_to :recorder, inverse_of: :options
end
