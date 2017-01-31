require 'test_helper'

class RecordersSetupTest < ActionDispatch::IntegrationTest

  test "invalid setup information" do
    get setup_path
    assert_no_difference 'Recorder.count' do
      assert_no_difference 'Option.count' do
        post setup_path, params: { recorder: { title: "",
                                               options_attributes: { "0" => { name: "hoge",
                                                                          _destroy: false } } } }
      end
    end
    assert_template 'recorders/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "valid setup information" do
    get setup_path
    assert_difference 'Recorder.count', 1 do
      assert_difference 'Option.count', 1 do
        post setup_path, params: { recorder: { title: "example",
                                               options_attributes: { "0" => { name: "hoge",
                                                                          _destroy: false } } } }
      end
    end
    follow_redirect!
    assert_template 'recorders/show'
  end

  test "register multiple options" do
    get setup_path
    assert_difference 'Recorder.count', 1 do
      assert_difference 'Option.count', 3 do
        post setup_path, params: { recorder: { title: "example",
                                               options_attributes: { "0" => { name: "hoge",
                                                                          _destroy: false },
                                                                     "1" => { name: "piyo",
                                                                          _destroy: false },
                                                                     "2" => { name: "fuga",
                                                                          _destroy: false } } } }
      end
    end
    follow_redirect!
    assert_template 'recorders/show'
  end
end
