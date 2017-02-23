class OptionsController < ApplicationController
  before_action :logged_in_user
  before_action -> {
    correct_user(parent_user_id)
  }, only: [:create, :new, :edit, :update]
  before_action -> {
    correct_user(grand_parent_user_id)
  }, only: [:destroy]

  def new
    @recorder = @user.recorders.build
    @recorder.options.build
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

  def destroy
    @option.destroy
    flash[:success] = "Option deleted!"
    redirect_to recorder_url(@recorder)
  end

  private

    def option_params
      strong = params.require(:recorder).permit(:title, options_attributes: [:id, :name, :recorder_id, :_destroy])
      strong[:options_attributes] = strong[:options_attributes].select {|n, options_attribute| !options_attribute[:name].blank?}
      return strong
    end

    def parent_user_id
      @recorder = Recorder.find(params[:recorder_id])
      @recorder.user_id
    end

    def grand_parent_user_id
      @option = Option.find(params[:id])
      @recorder = Recorder.find(@option.recorder_id)
      @recorder.user_id
    end
end
