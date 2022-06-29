# frozen_string_literal: true

# The table below maps how each input from the laboratory results file
# should be mapped to the class LaboratoryTestResult
class LaboratoryTestResult
  # common constant records.
  RESULT_CODE = { 'C100': 'float', 'C200': 'float', 'A250': 'boolean', 'B250': 'nil_3plus' }.freeze
  LABORATORY_RESULT_FORMAT = {
    float: ['20' => 20.0],
    boolean: [{ 'NEGATIVE' => -1.0 }, { 'POSITIVE' => -2.0 }],
    nil_3plus: [{ NIL: -1.0 }, { '+' => -2.0 }, { '++'	=> -2.0 }, { '+++'	=> -3.0 }]
  }.freeze

  attr_accessor :code, :result, :format, :comment

  def initialize(code, result, comment)
    @code = code
    @format = result_code_format(code)
    @result = laboratory_test_format(@format, result)
    @comment = comment
  end

  def laboratory_test_format(value, input)
    LABORATORY_RESULT_FORMAT[value.to_sym].find { |h, _| h.key?(input.first) }.values.first
  end

  def result_code_format(value)
    RESULT_CODE[value.to_sym]
  end
end
