module RecorderFamily
  private

    def update_recorder
      @recorder.touch
      @recorder.save
    end

    def delete_empty_recordabilities
      @recorder.recordabilities.each do |recordability|
        recordability.mark_for_destruction if recordability.records.empty?
      end
      @recorder.save
    end
end
