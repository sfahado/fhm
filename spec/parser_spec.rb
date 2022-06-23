# frozen_string_literal: true

require 'rspec'
require_relative '../parser'
require 'byebug'

describe Parser do
  let(:parser) { true }
  let(:correct_file) { File.open('./lab2.txt', 'r') }
  let(:incorrect_file) { File.open('./lab2-1.txt', 'r') }
  let(:empty_file) { File.open('./empty-lab.txt', 'r') }

  subject { Parser.new(correct_file) }

  describe '#Parser .initialize' do
    context "file don't have correct path" do
      it 'return error with incorrect file path' do
        expect { Parser.new(incorrect_file) }.to raise_error(StandardError)
      end
    end

    context 'file with correct data' do
      it 'correct file' do
        expect(subject.instance_variable_get(:@file)).to be_an_instance_of(File)
      end

      it 'should have comments' do
        expect(subject.instance_variable_get(:@lab_comment)).to be_an_instance_of(Array)
        expect(subject.instance_variable_get(:@lab_comment)).to be_empty
      end

      it 'should have data' do
        expect(subject.instance_variable_get(:@lab_data)).to be_an_instance_of(Array)
        expect(subject.instance_variable_get(:@lab_data)).to be_empty
      end

      it 'should have records' do
        expect(subject.instance_variable_get(:@lab_records)).to be_an_instance_of(Hash)
        expect(subject.instance_variable_get(:@lab_records)).to be_empty
      end
    end
  end

  describe '#Parser .call' do
    context 'when data is filled with records from array' do
      before do
        subject.send(:call)
      end
      it 'should have records' do
        expect(subject.instance_variable_get(:@lab_records)).not_to be_empty
      end

      it 'should contain correct records' do
        expect(subject.instance_variable_get(:@lab_records).length).to eql 3
      end

      context 'check data-structure is accurately filled' do
        before do
          subject.send(:call)
          @records = subject.instance_variable_get(:@lab_records)
          @key = @records.keys.sample
        end
        it 'should contain some lab records' do
          expect(@records[@key]).to be_an_instance_of(Array)
          expect(@records[@key]).not_to be_empty
        end

        it 'should contain correct records' do
          expect(@records[@key].length).to be >= 2
        end

        it 'should contain OBX record' do
          expect(@records[@key].first.join('')).to include('OBX')
        end

        it 'should contain NTE record' do
          expect(@records[@key].drop(1).first.join('')).to include('NTE')
        end
      end
    end

    context 'when data not filled for empty records' do
      before do
        @empty_parser = Parser.new(empty_file)
        subject.send(:call)
      end

      it 'do not raise error' do
        expect { @empty_parser }.not_to raise_error
      end

      it 'should have empty records' do
        expect(@empty_parser.instance_variable_get(:@lab_records)).to be_empty
      end

      it 'should contain correct records' do
        expect(@empty_parser.instance_variable_get(:@lab_records).length).to be_zero
      end

      it "should say 'No records in the file" do
        expect do
          @empty_parser.send(:call)
        end.to output(/No records in the file/).to_stdout
      end

      context 'check data-structure is empty filled' do
        before do
          @empty_parser = Parser.new(empty_file)
          @empty_parser.send(:call)
          @records = @empty_parser.instance_variable_get(:@lab_records)
          @key = @records.keys.sample
        end
        it 'should contain some lab records' do
          expect(@records[@key]).to be_an_instance_of(NilClass)
        end

        it 'should contain correct records' do
          expect(@records[@key]&.length).to be_an_instance_of(NilClass)
        end
      end
    end
  end

  describe '#Parser .mapped_results' do
    context 'when data is filled with records from array' do
      before do
        @lab_results = subject.mapped_results
        @records = subject.instance_variable_get(:@lab_records)
        @key = @records.keys.sample
        @single_result = @lab_results[@key.to_i - 1]
      end

      it 'should have records' do
        expect(@records).not_to be_empty
      end

      it 'should contain correct records' do
        expect(@records.keys.count).to eql 3
      end

      it 'should contain some lab records' do
        expect(@records[@key]).to be_an_instance_of(Array)
        expect(@records[@key]).not_to be_empty
      end

      it 'should contain correct records' do
        expect(@records[@key].length).to be >= 2
      end

      it 'should contain OBX record' do
        expect(@records[@key].first).to include('OBX')
      end

      it 'should contain NTE record' do
        expect(@records[@key].drop(1).first).to include('NTE')
      end

      it 'returned object is of LaboratoryTestResult type' do
        expect(@single_result).to be_an_instance_of(LaboratoryTestResult)
      end

      it 'check LaboratoryTestResult object' do
        record = @records[@key].first.split('|').include?(@single_result.code)
        expect(@single_result.code).not_to be_empty
        expect(record).to be_truthy
        expect(@single_result.comment.gsub('\\n',
                                           ' ')).to be_include(@records[@key].drop(1).sample.split('|')[2..-1].join('').strip)
        expect(LaboratoryTestResult::RESULT_CODE.values.include?(@single_result.format)).to be_truthy
      end
    end
  end
end
