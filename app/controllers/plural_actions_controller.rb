class PluralActionsController < ApplicationController
  include RecorderCommons
  before_action -> {
    logged_in_user(recorder_url(parent_of_records))
  }, only: [:delete_records, :destroy_records]
  before_action -> {
    logged_in_user(edit_recorder_url(parent_of_options))
  }, only: [:delete_options, :destroy_options]
  before_action -> {
    correct_user(ancestoral_user)
  }

  def delete_options
    @objects = @checked
    get_modal_window
  end

  def destroy_options
    plural_destroy
    @options = @recorder.options.all
    hide_modal_window @recorder,
                      "options/options_table",
                      ".options_table"
  end

  def delete_records
    @objects = @checked
    get_modal_window
  end

  def destroy_records
    plural_destroy
    @records = @recorder.records.all
    @options = @records.options.all
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
    end

    def parent_of_options
      @checked = Option.find(checked_ids)
      @recorder = @checked.first.recorder
    end

    def ancestoral_user
      @user = @recorder.user
    end

    def plural_destroy
      @checked.each do |c|
        c.destroy
      end
      update_recorder
    end
end
