class RecordsController < ApplicationController

  def create
    @recorder = Recorder.find(params[:parent_id])
    @record = @recorder.records.build(data: params[:commit])
    if @record.save
      flash[:success] = "saved!"
      redirect_to @recorder
    else
      @recorder.reload
    end
  end

  def destroy
  end

  private

    def record_params
      params.require(:record).permit(:commit)
    end
end
