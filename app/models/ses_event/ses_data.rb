# frozen_string_literal: true

module SesEvent
  class SesData
    attr_reader :receipt, :mail

    def initialize(data)
      @receipt = Receipt.new(data["receipt"] || {})
      @mail    = Mail.new(data["mail"] || {})
    end
  end
end
