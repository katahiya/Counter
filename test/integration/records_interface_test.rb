require 'test_helper'

class RecordsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:hoge)
    @recorder = recorders(:hoge)
    @option = @recorder.options.first
  end

  test "record interface with friendly forwarding" do
    get recorder_path(@recorder)
    log_in_as(@user)
    assert_redirected_to recorder_url(@recorder)
    follow_redirect!
    #valid
    before_count = @option.records.count
    assert_select "table td.record-data", text: @option.name, count: before_count
    assert_difference 'Record.count', 1 do
      post option_records_path(@option)
    end
    assert_redirected_to recorder_url(@recorder)
    follow_redirect!
    assert_select "table td.record-data", text: @option.name, count: before_count+1
    #destroy
    assert_select 'a', text: 'delete'
    first_record = @recorder.records.first
    assert_difference 'Record.count', -1 do
      delete record_path(first_record)
    end
  end
end
