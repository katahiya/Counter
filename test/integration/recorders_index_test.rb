require 'test_helper'

class RecordersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @recorder = recorders(:hoge)
  end

  test "index including pagination" do
    get recorders_path
    assert_template 'recorders/index'
    assert_select 'div.pagination'
    Recorder.paginate(page: 1).each do |recorder|
      assert_select 'a[href=?]', recorder_path(recorder), title: recorder.title
    end
  end
end
