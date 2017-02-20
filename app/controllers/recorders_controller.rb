class RecordersController < ApplicationController
  before_action :logged_in_user
  before_action -> {
    correct_user(parent_user_id)
  }, only: [:show, :edit, :update, :destroy]

  def new
    @recorder = current_user.recorders.build
    @recorder.options.build
  end

  def show
    @records = @recorder.records.all
    @record = @recorder.records.build
  end

  def create
    @recorder = current_user.recorders.build(recorder_params)
    if @recorder.save
      flash[:success] = "new recorder successfully created!"
      redirect_to @recorder
    else
      render 'new'
    end
  end

  def edit
    @recorder.options.build
  end

  def update
    if @recorder.update_attributes(recorder_params)
      flash[:succes] = "Counter updated"
      redirect_to @recorder
    else
      render 'edit'
    end
  end

  def index
    @recorders = Recorder.paginate(page: params[:page])
  end

  def destroy
    @recorder.destroy
    flash[:success] = "Recorder deleted!"
    redirect_to recorders_url
  end

  private

    def recorder_params
      params.require(:recorder).permit(:title, options_attributes: [:id, :name, :recorder_id, :_destroy])
    end

    def parent_user_id
      @recorder = Recorder.find(params[:id])
      @recorder.user_id
    end
end
