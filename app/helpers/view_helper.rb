module ViewHelper

  def record_index(record)
    Array(@recorder.records).reverse.index(record) + 1
  end
end
