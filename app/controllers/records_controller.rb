class RecordsController < ApplicationController
  include RecorderFamily
  before_action :logged_in_user, except: [:delete, :destroy]
  before_action -> {
    logged_in_user(user_recorders_url(user_id_of_destroy))
  }, only: [:delete, :destroy]
  before_action -> {
    correct_user(user_id_of_create)
  }, only: [:create]
  before_action -> {
    correct_user(user_id_of_destroy)
  }, only: [:delete, :destroy]

  def create
    @record = @recorder.records.build(option: @option)
    if @record.save
      update_recorder
      flash[:success] = "saved!"
      redirect_to @recorder
    else
      @recorder.reload
    end
  end

  def delete
    get_modal_window
  end

  def destroy
    @record.destroy
    update_recorder
    @records = @recorder.records.all
    hide_modal_window @record,
                      "shared/records_table",
                      ".records-body"
  end

  private

    def user_id_of_create
      @option = Option.find(params[:option_id])
      @recorder = @option.recorder
      @recorder.user_id
    end

    def user_id_of_destroy
      @record = Record.find(params[:id])
      @recorder = @record.recorder
      @recorder.user_id
    end

end
