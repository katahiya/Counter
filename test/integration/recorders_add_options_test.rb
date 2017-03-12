require 'test_helper'

class RecordersAddOptionsTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:hoge)
    @recorder = recorders(:hoge)
  end

  test "valid setup information with friendly forwarding" do
    get recorder_add_options_path(@user), xhr: true
    log_in_as(@user)
    assert_redirected_to edit_recorder_path(@recorder)
    follow_redirect!
    assert_no_difference 'Recorder.count' do
      assert_difference '@recorder.options.count', 1 do
        patch recorder_add_options_path(@recorder), xhr: true,
                                                   params: { recorder: { title: @recorder.title,
                                                              options_attributes: { "0" => { name: "hoge",
                                                                                             _destroy: false } } } }
      end
    end
    follow_redirect!
    assert_template 'recorders/show'
    assert_not flash.empty?
  end

  test "add multiple options with blank option" do
    log_in_as(@user)
    get edit_recorder_path(@recorder)
    request.env["HTTP_REFERER"] = edit_recorder_path(@recorder)
    get recorder_add_options_path(@recorder), xhr: true
    assert_no_difference 'Recorder.count' do
      assert_difference '@recorder.options.count', 3 do
        patch recorder_add_options_path(@recorder), xhr: true,
                                                  params: { recorder: { title: @recorder.title,
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
  end

end
