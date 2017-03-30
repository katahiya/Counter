class GraphController < ApplicationController
  before_action -> {
    logged_in_user(recorder_url(current_recorder))
  }
  before_action -> {
    correct_user(parent_user.id)
  }

  def show
    @data = @recorder.options.map do |option|
      option.records.empty? ? count = 0 :
        count = option.records.map{ |r| r.count }.inject(:+)
      [option.name, count]
    end
    @data.sort!{|a, b| b[1] <=> a[1]}
  end

  private
    def current_recorder
      @recorder = Recorder.find(params[:id])
    end

    def parent_user
      @recorder.user
    end
end
