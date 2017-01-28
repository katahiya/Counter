class RecordersController < ApplicationController
  def new
    @recorder = Recorder.new
  end

  def show
    @recorder = Recorder.find(params[:id])
  end
end
