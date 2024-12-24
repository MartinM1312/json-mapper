# frozen_string_literal: true

module SesEvent
  class DmarcVerdict
    attr_reader :status

    def initialize(data)
      @status = data["status"]
    end
  end
end
