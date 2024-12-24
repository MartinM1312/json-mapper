# frozen_string_literal: true

module SesEvent
  class Mail
    attr_reader :timestamp,
                :source,
                :message_id,
                :destination,
                :headers_truncated,
                :headers,
                :common_headers

    def initialize(data)
      @timestamp         = data["timestamp"]
      @source            = data["source"]
      @message_id        = data["messageId"]
      @destination       = data["destination"] || []
      @headers_truncated = data["headersTruncated"]
      @headers           = (data["headers"] || []).map { |h| MailHeader.new(h) }
      @common_headers    = CommonHeaders.new(data["commonHeaders"] || {})
    end
  end
end
