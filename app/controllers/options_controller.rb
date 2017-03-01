class OptionsController < ApplicationController
  before_action :logged_in_user, except: [:edit, :update]
  before_action -> {
    logged_in_user(recorder_options_url(parent_recorder))
  }, only: [:edit, :update]
  before_action -> {
    correct_user(parent_user.id)
  }, only: [:index, :create, :new]
  before_action -> {
    correct_user(grand_parent_user.id)
  }, only: [:destroy, :edit, :update]

  def index
    @options = @recorder.options
  end

  def edit
  end

  def update
    @option.update_attributes(single_option_params)
    @options = @recorder.options
  end

  def destroy
    @option.destroy
    flash[:success] = "Option deleted!"
    redirect_to recorder_options_url(@recorder)
  end

  private

    def option_params
      strong = params.require(:recorder).permit(:title, options_attributes: [:id, :name, :recorder_id, :_destroy])
      strong[:options_attributes] = strong[:options_attributes].select {|n, options_attribute| !options_attribute[:name].blank?}
      return strong
    end

    def single_option_params
      params.require(:option).permit(:name)
    end

    def parent_user
      @recorder = Recorder.find(params[:recorder_id])
      @user = @recorder.user
    end

    def grand_parent_user
      @user = parent_recorder.user
    end

    def parent_recorder
      @option = Option.find(params[:id])
      @recorder = @option.recorder
    end
end
