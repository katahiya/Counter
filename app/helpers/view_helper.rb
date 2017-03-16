module ViewHelper

  def record_index(record)
    Array(@recorder.records).reverse.index(record) + 1
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
