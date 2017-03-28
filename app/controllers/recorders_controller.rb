class RecordersController < ApplicationController
  include RecorderFamily
  before_action :logged_in_user, except: [:edit_title, :update_title, :add_options, :update_options, :delete, :destroy]
  before_action -> {
    logged_in_user(user_recorders_url(parent_user_id))
  }, only: [:delete, :destroy]
  before_action -> {
    logged_in_user(edit_recorder_url(Recorder.find(params[:id])))
  }, only: [:edit_title, :update_title, :add_options, :update_options]
  before_action -> {
    correct_user(parent_user_id)
  }, only: [:show, :add_options, :edit_title, :update_title, :edit, :update, :update_options, :delete, :destroy]
  before_action -> {
    correct_user(params[:user_id])
  }, only: [:index, :create, :new]

  def new
    @recorder = @user.recorders.build
    @recorder.options.build
  end

  def show
    @recordabilities = @recorder.recordabilities.all
    @recordability = @recorder.recordabilities.build
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
    @options = @recorder.options
  end

  def update
    if @recorder.update_attributes(recorder_params)
      flash[:success] = "#{@recorder.title} successfully updated!"
      redirect_to @recorder
    else
      render 'recorders/edit'
    end
  end

  def edit_title
    get_modal_window
  end

  def update_title
    @recorder.update_attributes(recorder_title)
    @recorders = @user.recorders.paginate(page: params[:page])
    hide_modal_window @recorder,
                      "recorder_title",
                      ".recorder-#{@recorder.id}_title",
                      recorder: @recorder
  end

  def add_options
    @recorder.options.build
    get_modal_window
  end

  def update_options
    if option_blank_all? recorder_params[:options_attributes]
      @recorder.no_input_error
    elsif
      @recorder.update_attributes(recorder_params)
      update_recorder
    end
    @options = @recorder.options
    if from_edit?
      hide_modal_window @recorder,
                        "options/options_table",
                        ".options_table"
    elsif from_show?
      hide_modal_window @recorder,
                        "shared/record_form",
                        ".record_form"
    else
      redirect_to(:back)
    end
  end

  def index
    @recorders = @user.recorders.paginate(page: params[:page])
  end

  def delete
    get_modal_window
  end

  def destroy
    @recorder.destroy
    @recorders = @user.recorders.paginate(page: params[:page])
    flash[:success] = "1つのカウンターが削除されました"
    redirect_to user_recorders_url(@user)
  end

  private

    def recorder_title
      params.require(:recorder).permit(:title)
    end

    def recorder_params
      params.require(:recorder).permit(:title, options_attributes: [:id, :name, :recorder_id, :_destroy])
    end

    def recorder_title
      params.require(:recorder).permit(:title)
    end

    def parent_user_id
      @recorder = Recorder.find(params[:id])
      @recorder.user_id
    end

    def before_actions
      Rails.application.routes.recognize_path(request.referrer)
    end

    def from_show?
      before_actions[:controller] == "recorders" && before_actions[:action] == "show"
    end

    def from_edit?
      before_actions[:controller] == "recorders" && before_actions[:action] == "edit"
    end

    def option_blank_all?(options_attributes)
      options_attributes.each { |index, attr| return false unless attr[:name].blank? }
      return true
    end
end
