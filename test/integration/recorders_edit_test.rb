require 'test_helper'

class RecordersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:hoge)
    @recorder = recorders(:hoge)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_recorder_path(@recorder)
    assert_template 'recorders/edit'
    patch recorder_path(@recorder), params: { recorder: { title: "",
                                              options_attributes: { "0" => { name: "hoge",
                                                                             _destroy: false } } } }
    assert_template 'recorders/edit'
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_recorder_path(@recorder)
    assert_template 'recorders/edit'
    title = "onion"
    option_name = "kinoko"
    patch recorder_path(@recorder), params: { recorder: { title: title,
                                                          options_attributes: { "0" => { name: option_name,
                                                                                         _destroy: false } } } }
    assert_not flash.empty?
    assert_redirected_to @recorder
    @recorder.reload
    assert_equal title, @recorder.title
    assert_equal option_name, @recorder.options.last.name
  end
end
