class BatchRegistrationController < ApplicationController
  include RecorderFamily
  before_action -> {
    logged_in_user(recorder_url(current_recorder))
  }

  def new
    get_modal_window
  end

  def create
  end


  private

    def current_recorder
      @recorder = Recorder.find(params[:id])
    end

end
