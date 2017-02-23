require 'test_helper'

class OptionEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:hoge)
    @recorder = recorders(:hoge)
    @option = option(:hoge)
  end

  test "edit page layout" do
    
  end
end
