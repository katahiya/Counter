class RecordsController < ApplicationController
  before_action :logged_in_user
  before_action -> {
    correct_user(user_id_of_create)
  }, only: [:create]
  before_action -> {
    correct_user(user_id_of_destroy)
  }, only: [:destroy]

  def create
    @record = @recorder.records.build(option: @option)
    if @record.save
      flash[:success] = "saved!"
      redirect_to @recorder
    else
      @recorder.reload
    end
  end

  def destroy
    @record.destroy
    flash[:succes] = "deleted!"
    redirect_to @recorder
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
