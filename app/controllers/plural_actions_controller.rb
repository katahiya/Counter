class PluralActionsController < ApplicationController
  include RecorderFamily
  before_action -> {
    logged_in_user(recorder_url(parent_of_recordabilities))
  }, only: [:delete_recordabilities, :destroy_recordabilities]
  before_action -> {
    logged_in_user(edit_recorder_url(parent_of_options))
  }, only: [:delete_options, :destroy_options]
  before_action -> {
    correct_user(ancestoral_user.id)
  }

  def delete_options
    @objects = @checked
    get_modal_window
  end

  def destroy_options
    Option.transaction do
      plural_destroy '選択肢'
    end
    delete_empty_recordabilities
    @options = @recorder.options.all
    hide_modal_window @recorder,
                      "options/options_table",
                      ".options_table"
  end

  def delete_recordabilities
    @objects = @checked
    get_modal_window
  end

  def destroy_recordabilities
    Recordability.transaction do
      plural_destroy '記録'
    end
    @recordabilities = @recorder.recordabilities.all
    @options = @recorder.options.all
    hide_modal_window @recorder,
                      "recorders/records_table",
                      ".records-body"
  end

  private

    def checked_ids
      params.require(:ids)
    end

    def parent_of_recordabilities
      @checked = Recordability.find(checked_ids)
      @recorder = @checked.first.recorder
    end

    def parent_of_options
      @checked = Option.find(checked_ids)
      @recorder = @checked.first.recorder
    end

    def ancestoral_user
      @user = @recorder.user
    end

    def plural_destroy(name=nil)
      count = @checked.count
      @checked.each do |c|
        c.destroy
      end
      update_recorder
      flash[:success] = "#{count}個の#{name}を削除しました" if name
    end
end
