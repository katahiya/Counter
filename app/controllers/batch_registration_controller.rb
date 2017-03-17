class BatchRegistrationController < ApplicationController
  include RecorderFamily
  before_action -> {
    logged_in_user(recorder_url(current_recorder))
  }

  def new
    @recorder.options.count.times do
      @recorder.records.build
    end
    get_modal_window
  end

  def create
    @recorder.update_attributes(recorder_params)
    update_recorder
    @records = @recorder.records
    hide_modal_window @recorder,
                      "shared/records_table",
                      ".records-body",
                      recorder: @recorder
  end


  private

    def current_recorder
      @recorder = Recorder.find(params[:id])
    end

    def recorder_params
      params[:recorder][:records_attributes].select!{ |index, attr| attr[:count].to_i > 0 }
      params.require(:recorder).permit(records_attributes: [:count, :option_id])
    end

end
