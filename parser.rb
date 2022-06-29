# frozen_string_literal: true

require './laboratory_test_result'
require './lib/parser_util'
require 'byebug'

# class to Implement read and parse a text file which represents some laboratory test results.
class Parser
  include ParserUtil
  attr_accessor :file, :lab_code, :lab_data, :lab_comment, :lab_records

  def initialize(file_path)
    @file = File.open(file_path, 'r')
    @lab_comment, @lab_data = Array.new(2, [])
    @lab_records = {}
  rescue Errno::ENOENT => e
    puts e.message.to_s
    raise StandardError, e.message.to_s
  end

  def mapped_results
    call
    lab_results = []
    lab_records.each_pair do |_, lab_records|
      record = lab_records.flatten!
      lab_index = record_indices(record, 'OBX')
      comment_indices = record_indices(record, 'NTE')
      lab_index.each do |i|
        @lab_code, *@lab_data = splitting(record, i)
      end
      comment_indices.each do |j|
        first, = splitting(record, j)
        @lab_comment << first
      end
      lab_results << LaboratoryTestResult.new(lab_code, lab_data, lab_comment.join('\n'))
    end
    lab_results
  end

  private

  def call
    file_records = []
    if file && !File.zero?(file)
      file.each_line do |line|
        _, *rest = line.split('|')
        file_records << line
        initialize_or_fill(rest.first) unless key_exist?(rest.first)
        if key_exist?(rest.first)
          initialize_or_fill(rest.first, file_records)
          file_records = []
        end
      end
    else
      puts 'No records in the file'
    end
  end

  def initialize_or_fill(index, lab_records = [])
    if lab_records.empty?
      @lab_records[index] = []
    else
      @lab_records[index] << lab_records
    end
  end

  def key_exist?(identifier)
    lab_records.key?(identifier)
  end
end

parser = Parser.new('./lab2.txt')
print parser.mapped_results.inspect
