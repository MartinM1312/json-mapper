# frozen_string_literal: true

module SesEvent
  class Event
    attr_reader :records

    def initialize(data)
      raw_records = data["Records"] || []
      @records    = raw_records.map { |r| Record.new(r) }
    end
  end
end
