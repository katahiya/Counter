require 'rails_helper'
require 'helpers'

RSpec.configure do |c|
  c.include Helpers
end


RSpec.feature "Modals", type: :feature, js: true do
  let(:user ) { create(:user, :with_descendants) }
  let(:recorder) { user.recorders.first }
end
