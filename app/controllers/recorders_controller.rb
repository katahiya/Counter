class RecordersController < ApplicationController
  def new
    @recorder = Recorder.new
    @recorder.options.build
  end

  def show
    @recorder = Recorder.find(params[:id])
  end

  private
    def recorder_params
      params.require(:recorder).permit(:title, options_attributes: [:id, :name, :recorder_id, :_destroy])
    end
end
