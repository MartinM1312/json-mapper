# frozen_string_literal: true

module SesEvent
  class Receipt
    attr_reader :timestamp,
                :processing_time_millis,
                :recipients,
                :spam_verdict,
                :virus_verdict,
                :spf_verdict,
                :dkim_verdict,
                :dmarc_verdict,
                :dmarc_policy,
                :action

    def initialize(data)
      @timestamp              = data["timestamp"]
      @processing_time_millis = data["processingTimeMillis"]
      @recipients             = data["recipients"] || []
      @spam_verdict           = SpamVerdict.new(data["spamVerdict"] || {})
      @virus_verdict          = VirusVerdict.new(data["virusVerdict"] || {})
      @spf_verdict            = SpfVerdict.new(data["spfVerdict"] || {})
      @dkim_verdict           = DkimVerdict.new(data["dkimVerdict"] || {})
      @dmarc_verdict          = DmarcVerdict.new(data["dmarcVerdict"] || {})
      @dmarc_policy           = data["dmarcPolicy"]
      @action                 = Action.new(data["action"] || {})
    end
  end
end
