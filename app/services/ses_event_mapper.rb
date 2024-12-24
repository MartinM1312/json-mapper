# frozen_string_literal: true

class SesEventMapper
  def self.call(event_data)
    event = SesEvent::Event.new(event_data)
    responses = []
    event.records.each do |record|
      receipt = record.ses.receipt
      mail    = record.ses.mail

      new_hash = {
        spam: spam?(receipt.spam_verdict.status),
        virus: spam?(receipt.virus_verdict.status),
        dns: dns_check?(receipt),
        month: month_from_timestamp(mail.timestamp),
        delayed: delayed?(receipt.processing_time_millis),
        transmitter: extract_user_part(mail.source),
        receiver: mail.destination.map { |d| extract_user_part(d) }
      }
      responses << new_hash
    end
    responses
  end

  class << self
    private

    def spam?(status)
      status == "PASS"
    end

    def dns_check?(receipt)
      receipt.spf_verdict.status == "PASS" &&
        receipt.dkim_verdict.status == "PASS" &&
        receipt.dmarc_verdict.status == "PASS"
    end

    def month_from_timestamp(timestamp)
      require "date"
      Date.parse(timestamp).strftime("%B") rescue "Unknown"
    end

    def delayed?(processing_time)
      processing_time.to_i > 1000
    end

    def extract_user_part(email)
      email.to_s.split("@").first
    end
  end
end
