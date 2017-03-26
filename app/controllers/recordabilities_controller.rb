class RecordabilitiesController < ApplicationController
  include RecorderFamily
  before_action -> {
    logged_in_user(recorder_url(current_recorder))
  }, only: [:new, :create]
  before_action -> {
    logged_in_user(recorder_url(parent_recorder))
  }, only: [:edit, :update, :delete, :destroy]
  before_action -> {
    correct_user(parent_user.id)
  }

  def new
    @recordability = @recorder.recordabilities.build
    @recorder.options.count.times do
      @recordability.records.build
    end
    get_modal_window
  end

  def create
    @recordability = @recorder.recordabilities.build
    if recorder_params[:recordability][:records_attributes].empty?
      @recordability.unrecordable_error
    elsif
      Recordability.transaction do
        Record.transaction do
          @recordability.save
          @recordability.update_attributes(recorder_params[:recordability])
          update_recorder
        end
      end
    end
    @recordabilities = @recorder.recordabilities
    hide_modal_window @recordability,
                      "recorders/records_table",
                      ".records-body"
  end

  def edit
    registered_options = @recordability.records.pluck :option_id
    @recorder.options.each do |option|
      @recordability.records.build(option: option) unless registered_options.include?(option.id)
    end
    get_modal_window
  end

  def update
    Recordability.transaction do Record.transaction do
        @recordability.update_attributes(recordability_params)
        update_recorder
      end
    end
    @recordabilities = @recorder.recordabilities
    hide_modal_window @recorder,
                      "recorders/records_table",
                      ".records-body"
  end

  def delete
    get_modal_window
  end

  def destroy
    @recordability.destroy
    update_recorder
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
      params[:recorder][:recordability][:records_attributes].select! { |index, attr| attr[:count].to_i > 0 }
      params.require(:recorder).permit(recordability: { records_attributes: [:count, :option_id] })
    end

    def recordability_params
      params[:recordability][:records_attributes].select! { |index, attr| attr[:count].to_i > 0 }
      params.require(:recordability).permit(records_attributes: [:count, :option_id, :id])
    end
end
