# frozen_string_literal: true

# Module to place some common methods.
module ParserUtil
  def record_indices(record, matcher)
    record.each_index.select { |i| record[i].include?(matcher) }.compact
  end

  def splitting(record, index)
    record[index].split('|')[2..-1]
  end
end
