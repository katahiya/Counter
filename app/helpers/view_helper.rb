module ViewHelper

  def record_index(record)
    Array(@recorder.records).reverse.index(record) + 1
  end

  def recordability_index(recordability)
    Array(@recorder.recordabilities).reverse.index(recordability)
  end

  def new_fields_for(f, model)
    fields = []
    f.fields_for model do |m|
      next unless m.object.id.nil?
      fields.append(m)
    end
    fields
  end
end
