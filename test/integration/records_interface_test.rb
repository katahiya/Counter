require 'test_helper'

class RecordsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @recorder = recorders(:hoge)
  end

  test "record interface" do
    get recorder_path(@recorder)
    #invalid
    assert_no_difference 'Record.count' do
      post records_path, params: { commit: "", parent_id: @recorder.id }
    end
    #valid
    data = "test data"
    assert_difference 'Record.count', 1 do
      post records_path, params: { commit: data, parent_id: @recorder.id }
    end
    assert_redirected_to recorder_path(@recorder)
    follow_redirect!
    assert_match data, response.body
    #destroy
    assert_select 'a', text: 'delete'
    first_record = @recorder.records.first
    assert_difference 'Record.count', -1 do
      delete record_path(first_record), params: { parent_id: @recorder.id }
    end
  end
end
