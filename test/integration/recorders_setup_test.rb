require 'test_helper'

class RecordersSetupTest < ActionDispatch::IntegrationTest

  test "invalid setup information" do
    get setup_path
    assert_no_difference 'Recorder.count' do
      post setup_path, params: { recorder: { title: "",
                                             option: { name: "hoge" } } }
    end
    assert_template 'recorders/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end
end
