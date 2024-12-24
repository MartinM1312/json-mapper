# frozen_string_literal: true

module SesEvent
  class CommonHeaders
    attr_reader :return_path, :from, :date, :to, :message_id, :subject

    def initialize(data)
      @return_path = data["returnPath"]
      @from        = data["from"] || []
      @date        = data["date"]
      @to          = data["to"] || []
      @message_id  = data["messageId"]
      @subject     = data["subject"]
    end
  end
end
