class PluralActionsController < ApplicationController
  include RecorderCommons
  before_action -> {
    logged_in_user(recorder_url(parent_of_records))
  }, only: [:delete_records, :destroy_records]
  before_action -> {
    correct_user(ancestoral_user)
  }


  def delete_records
    @objects = @checked
    get_modal_window
  end

  def destroy_records
    @checked.each do |record|
      record.destroy
    end
    update_recorder
    @records = @recorder.records.all
    hide_modal_window @recorder,
                      "shared/records_table",
                      ".records-body"
  end

  private

    def checked_ids
      params.require(:ids)
    end

    def parent_of_records
      @checked = Record.find(checked_ids)
      @recorder = @checked.first.recorder
      @user = @recorder.user
    end

    def ancestoral_user
      @recorder.user
    end
end
