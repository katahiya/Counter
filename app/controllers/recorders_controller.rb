class RecordersController < ApplicationController
  before_action :logged_in_user, except: [:edit, :update]
  before_action -> {
    logged_in_user(user_recorders_url(parent_user_id))
  }, only: [:edit, :update]
  before_action -> {
    correct_user(parent_user_id)
  }, only: [:show, :edit, :add_options, :update, :update_options, :delete, :destroy]
  before_action -> {
    correct_user(params[:user_id])
  }, only: [:index, :create, :new]

  def new
    @recorder = @user.recorders.build
    @recorder.options.build
  end

  def show
    @records = @recorder.records.all
    @record = @recorder.records.build
  end

  def create
    @recorder = @user.recorders.build(recorder_params)
    if @recorder.save
      flash[:success] = "new recorder successfully created!"
      redirect_to @recorder
    else
      render 'new'
    end
  end

  def edit
  end

  def add_options
    @recorder.options.build
  end

  def update
    @recorder.update_attributes(recorder_title)
    @recorders = @user.recorders.paginate(page: params[:page])
  end

  def update_options
    if @recorder.update_attributes(recorder_params)
      flash[:success] = "new recorder successfully created!"
      redirect_to @recorder
    else
      render 'add_options'
    end
  end

  def index
    @recorders = @user.recorders.paginate(page: params[:page])
  end

  def delete
  end

  def destroy
    @recorder.destroy
    @recorders = @user.recorders.paginate(page: params[:page])
    flash[:success] = "Recorder deleted!"
  end

  private

    def recorder_title
      params.require(:recorder).permit(:title)
    end

    def recorder_params
      strong = params.require(:recorder).permit(:title, options_attributes: [:id, :name, :recorder_id, :_destroy])
      strong[:options_attributes] = strong[:options_attributes].select {|n, options_attribute| !options_attribute[:name].blank?}
      return strong
    end

    def recorder_title
      params.require(:recorder).permit(:title)
    end

    def parent_user_id
      @recorder = Recorder.find(params[:id])
      @recorder.user_id
    end
end
