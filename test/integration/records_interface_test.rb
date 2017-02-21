require 'test_helper'

class RecordsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:hoge)
    @recorder = recorders(:hoge)
  end

  test "record interface with friendly forwarding" do
    get recorder_path(@recorder)
    log_in_as(@user)
    assert_redirected_to recorder_url(@recorder)
    follow_redirect!
    #invalid
    assert_no_difference 'Record.count' do
      post recorder_records_path(@recorder), params: { commit: "" }
    end
    #valid
    data = "test data"
    assert_difference 'Record.count', 1 do
      post recorder_records_path(@recorder), params: { commit: data }
    end
    assert_redirected_to recorder_url(@recorder)
    follow_redirect!
    assert_match data, response.body
    #destroy
    assert_select 'a', text: 'delete'
    first_record = @recorder.records.first
    assert_difference 'Record.count', -1 do
      delete record_path(first_record)
    end
  end
end
