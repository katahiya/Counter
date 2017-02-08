require 'test_helper'

class RecordersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @recorder = recorders(:hoge)
  end

  test "index including pagination and delete links" do
    get recorders_path
    assert_template 'recorders/index'
    assert_select 'div.pagination'
    first_page_of_recorders = Recorder.paginate(page: 1)
    first_page_of_recorders.each do |recorder|
      assert_select 'a[href=?]', recorder_path(recorder), title: recorder.title
      assert_select 'a[href=?]', recorder_path(recorder), text: 'delete'
    end
    assert_difference 'Recorder.count', -1 do
      delete recorder_path(@recorder)
    end
  end
end
