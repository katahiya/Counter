class RecordsController < ApplicationController

  def create
    @record = @recorder.records.build(record_params)
    if @record.save
      flash[:success] = "saved!"
      @recorder.reload
    else
      redirect_to @recorder
    end
  end

  def destroy
  end

  private

    def record_params
      params.require(:record).permit(:data)
    end
end
