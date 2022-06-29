# frozen_string_literal: true

require 'rspec'
require_relative '../laboratory_test_result'

describe LaboratoryTestResult do
  let(:lab_code) { 'A250' }
  let(:wrong_lab_code) { 'XA250' }
  let(:lab_data) { %W[NEGATIVE \n] }
  let(:lab_comment) { 'Comment for NEGATIVE result' }

  subject { LaboratoryTestResult.new(lab_code, lab_data, lab_comment) }

  describe '#LaboratoryTestResult .initialize' do
    it 'correct attr_accessor' do
      expect(subject.instance_variable_get(:@code)).to be_an_instance_of(String)
      expect(subject.instance_variable_get(:@result)).to be_an_instance_of(Float)
      expect(subject.instance_variable_get(:@format)).to be_an_instance_of(String)
      expect(subject.instance_variable_get(:@comment)).to be_an_instance_of(String)
    end

    it 'should check the constants RESULT_CODE & LABORATORY_RESULT_FORMAT' do
      expect(LaboratoryTestResult::RESULT_CODE).to be_an_instance_of(Hash)
      expect(LaboratoryTestResult::RESULT_CODE).not_to be_include(lab_code)
      expect(LaboratoryTestResult::LABORATORY_RESULT_FORMAT).to be_an_instance_of(Hash)
      expect(LaboratoryTestResult::LABORATORY_RESULT_FORMAT).not_to be_include(subject.instance_variable_get(:@format))
    end

    it 'should check the code' do
      expect(LaboratoryTestResult::RESULT_CODE.keys).to be_include(lab_code.to_sym)
      expect(LaboratoryTestResult::RESULT_CODE.values).to be_include(subject.instance_variable_get(:@format))
    end

    it 'should check the result_code_format' do
      expect(subject.result_code_format(lab_code)).to be_an_instance_of(String)
      expect(subject.result_code_format(lab_code)).not_to be_empty
      expect(LaboratoryTestResult::RESULT_CODE.values).to be_include(subject.result_code_format(lab_code))
    end

    it 'should check the wrong result_code_format' do
      expect(subject.result_code_format(wrong_lab_code)).to be_nil
      expect(LaboratoryTestResult::RESULT_CODE.values).not_to be_include(subject.result_code_format(wrong_lab_code))
    end

    it 'should check the result' do
      expect(subject.instance_variable_get(:@result)).to be_an_instance_of(Float)
    end

    it 'should check the laboratory_test_format' do
      expect(subject.laboratory_test_format(subject.result_code_format(lab_code), lab_data)).to be_an_instance_of(Float)
      expect(subject.laboratory_test_format(subject.result_code_format(lab_code), lab_data)).not_to be_nil
    end
  end
end
