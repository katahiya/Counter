class RecordabilitiesController < ApplicationController
  include RecorderFamily
  before_action -> {
    logged_in_user(recorder_url(current_recorder))
  }

  def new
    @recordability = @recorder.recordabilities.build
    @recorder.options.count.times do
      @recordability.records.build
    end
    get_modal_window
  end

  def create
    @recordability = @recorder.recordabilities.create
    @recordability.update_attributes(recorder_params[:recordability])
    update_recorder
    @recordabilities = @recorder.recordabilities
    @recordability = @recorder.recordabilities.build
    hide_modal_window @recorder,
                      "shared/records_table",
                      ".records-body"
  end


  private

    def current_recorder
      @recorder = Recorder.find(params[:recorder_id])
    end

    def recorder_params
      params[:recorder][:recordability][:records_attributes].select! { |index, attr| attr[:count].to_i > 0 }
      params.require(:recorder).permit(recordability: { records_attributes: [:count, :option_id] })
    end
end
