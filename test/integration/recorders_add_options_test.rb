require 'test_helper'

class RecordersAddOptionsTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:hoge)
    @recorder = recorders(:hoge)
  end

  test "valid setup information with friendly forwarding" do
    get recorder_add_options_path(@user)
    log_in_as(@user)
    assert_redirected_to recorder_add_options_path(@user)
    follow_redirect!
    assert_select "form[action=?]", recorder_path(@recorder)
    assert_no_difference 'Recorder.count' do
      assert_difference '@recorder.options.count', 1 do
        patch recorder_path(@recorder), params: { recorder: { title: @recorder.title,
                                                              options_attributes: { "0" => { name: "hoge",
                                                                                             _destroy: false } } } }
      end
    end
    follow_redirect!
    assert_template 'recorders/show'
    assert_not flash.empty?
  end

  test "setup multiple options with blank option" do
    log_in_as(@user)
    get recorder_add_options_path(@recorder)
    assert_select "form[action=?]", recorder_path(@recorder)
    assert_no_difference 'Recorder.count' do
      assert_difference '@recorder.options.count', 3 do
        patch recorder_path(@recorder), params: { recorder: { title: @recorder.title,
                                                                         options_attributes: { "0" => { name: "hoge",
                                                                                                    _destroy: false },
                                                                                               "1" => { name: "",
                                                                                                    _destroy: false },
                                                                                               "2" => { name: "piyo",
                                                                                                    _destroy: false },
                                                                                               "3" => { name: "      ",
                                                                                                    _destroy: false },
                                                                                               "4" => { name: "fuga",
                                                                                                    _destroy: false } } } }
      end
    end
    follow_redirect!
    assert_template 'recorders/show'
    assert_not flash.empty?
  end
end
