class RecordabilitiesController < ApplicationController
  include RecorderFamily
  before_action -> {
    logged_in_user(recorder_url(current_recorder))
  }, only: [:new, :create]
  before_action -> {
    logged_in_user(recorder_url(parent_recorder))
  }, only: [:duplicate, :edit, :update, :delete, :destroy]
  before_action -> {
    correct_user(parent_user.id)
  }

  def new
    @recordability = @recorder.recordabilities.build
    @recorder.options.count.times do
      @recordability.records.build
    end
    get_ajax_view(".cover-view")
  end

  def create
    @recordability = @recorder.recordabilities.build
    if count_zero_all? recorder_params[:recordability][:records_attributes]
      @recordability.unrecordable_error
    elsif
      Recordability.transaction do
        Record.transaction do
          @recordability.save!
          @recordability.update_attributes!(recorder_params[:recordability])
          update_recorder
          flash[:success] = "記録が追加されました"
        end
      end
    end
    @recordabilities = @recorder.recordabilities
    hide_modal_window @recordability,
                      "recorders/records_table",
                      ".records-body"
  end

  def duplicate
    @new = @recorder.recordabilities.build
    Recordability.transaction do
      Record.transaction do
        @new.save!
        @recordability.records.each do |record|
          @new.records.create!(option: record.option, count: record.count)
        end
        update_recorder
        flash[:success] = "記録が複製されました"
      end
    end
    @recordability = @new
    redirect_to @recorder
  end

  def edit
    registered_options = @recordability.records.pluck :option_id
    @recorder.options.each do |option|
      @recordability.records.build(option: option) unless registered_options.include?(option.id)
    end
    get_modal_window
  end

  def update
    if count_zero_all? recordability_params[:records_attributes]
      @recordability.unrecordable_error
    elsif
      Recordability.transaction do
        Record.transaction do
          @recordability.update_attributes!(recordability_params)
          update_recorder
          flash[:success] = "記録が変更されました"
        end
      end
    end
    @recordabilities = @recorder.recordabilities
    hide_modal_window @recordability,
                      "recorders/records_table",
                      ".records-body"
  end

  def delete
    get_modal_window
  end

  def destroy
    @recordability.destroy
    update_recorder
    flash[:success] = "記録が削除されました"
    @recordabilities = @recorder.recordabilities.all
    hide_modal_window @recorder,
                      "recorders/records_table",
                      ".records-body"
  end


  private

    def current_recorder
      @recorder = Recorder.find(params[:recorder_id])
    end

    def parent_recorder
      @recordability = Recordability.find(params[:id])
      @recorder = @recordability.recorder
    end

    def parent_user
      @recorder.user
    end

    def recorder_params
      params.require(:recorder).permit(recordability: { records_attributes: [:count, :option_id] })
    end

    def recordability_params
      params.require(:recordability).permit(records_attributes: [:count, :option_id, :id])
    end

    def count_zero_all?(records_attributes)
      records_attributes.each { |index, attr| return false if attr[:count].to_i > 0 }
      return true
    end
end
