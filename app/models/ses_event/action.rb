# frozen_string_literal: true

module SesEvent
  class Action
    attr_reader :type, :topic_arn

    def initialize(data)
      @type      = data["type"]
      @topic_arn = data["topicArn"]
    end
  end
end
