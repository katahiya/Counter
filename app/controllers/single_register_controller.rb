class SingleRegisterController < ApplicationController
  include RecorderFamily
  before_action :logged_in_user, except: [:delete, :destroy]
  before_action -> {
    logged_in_user(parent_user)
  }

  def create
    Recordability.transaction do
      Record.transaction do
        @recordability = @recorder.recordabilities.create!
        @record = @recordability.records.build(option: @option, count: 1)
        @record.save!
        update_recorder
      end
    end
    flash[:success] = "saved!"
    redirect_to @recorder
  end

  private

    def parent_user
      current_recorder.user
    end

    def current_recorder
      @option = Option.find(params[:id])
      @recorder = @option.recorder
    end
end
