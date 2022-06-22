# frozen_string_literal: true

require 'rspec'
require_relative '../parser'

describe Parser do
  let(:parser) { true }
  let(:correct_file) { File.open('./lab2.txt', 'r') }
  let(:incorrect_file) { File.open('./lab2-1.txt', 'r') }
  subject { Parser.new(correct_file) }

  describe '#Parser .initialize' do
    context "file don't have correct path" do
      it 'return error with incorrect file path' do
        expect { Parser.new(incorrect_file) }.to raise_error(StandardError)
      end
    end

    context 'file have correct path' do
      it 'correct file path' do
        expect { subject.instance_variable_get(:@file) }.not_to be_nil
      end
    end
  end
end
