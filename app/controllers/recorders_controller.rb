class RecordersController < ApplicationController
  def new
    @recorder = Recorder.new
    @recorder.options.build
  end

  def show
    @recorder = Recorder.find(params[:id])
  end

  def create
    @recorder = Recorder.new(recorder_params)
    if @recorder.save
      flash[:success] = "new recorder successfully created!"
      redirect_to @recorder
    else
      render 'new'
    end
  end

  def edit
    @recorder = Recorder.find(params[:id])
  end

  def update
    @recorder = Recorder.find(params[:id])
    if @recorder.update_attributes(recorder_params)
      flash[:succes] = "Counter updated"
      redirect_to @recorder
    else
      render 'edit'
    end
  end

  private
    def recorder_params
      params.require(:recorder).permit(:title, options_attributes: [:id, :name, :recorder_id, :_destroy])
    end
end
