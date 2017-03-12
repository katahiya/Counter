module RecorderCommons
  private

    def update_recorder
      @recorder.touch
      @recorder.save
    end
end
