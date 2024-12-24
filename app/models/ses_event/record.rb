# frozen_string_literal: true

module SesEvent
  class Record
    attr_reader :event_version, :event_source, :ses

    def initialize(data)
      @event_version = data["eventVersion"]
      @event_source  = data["eventSource"]
      @ses           = SesData.new(data["ses"] || {})
    end
  end
end
