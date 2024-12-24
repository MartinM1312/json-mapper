# frozen_string_literal: true

module SesEvent
  class MailHeader
    attr_reader :name, :value

    def initialize(data)
      @name  = data["name"]
      @value = data["value"]
    end
  end
end
