# spec/requests/ses_events_spec.rb
require 'rails_helper'

RSpec.describe "SesEvents", type: :request do
  describe "POST /ses_events/transform" do
    let(:valid_payload) do
      {
        Records: [
          {
            eventVersion: "1.0",
            ses: {
              receipt: {
                timestamp: "2015-09-11T20:32:33.936Z",
                processingTimeMillis: 222,
                recipients: [ "recipient@example.com" ],
                spamVerdict: { status: "PASS" },
                virusVerdict: { status: "PASS" },
                spfVerdict: { status: "PASS" },
                dkimVerdict: { status: "PASS" },
                dmarcVerdict: { status: "PASS" },
                dmarcPolicy: "reject",
                action: {
                  type: "SNS",
                  topicArn: "arn:aws:sns:us-east-1:012345678912:example-topic"
                }
              },
              mail: {
                timestamp: "2015-09-11T20:32:33.936Z",
                source: "61967230-7A45-4A9D-BEC9-87CBCF2211C9@example.com",
                messageId: "d6iitobk75ur44p8kdnnp7g2n800",
                destination: [ "recipient@example.com" ],
                headersTruncated: false,
                headers: [ { name: "From", value: "sender@example.com" } ],
                commonHeaders: {
                  returnPath: "0000014fbe1c09cf-7cb9f704-7531-4e53-89a1-5fa9744f5eb6-000000@amazonses.com",
                  from: [ "sender@example.com" ],
                  date: "Fri, 11 Sep 2015 20:32:32 +0000",
                  to: [ "recipient@example.com" ],
                  messageId: "<61967230-7A45-4A9D-BEC9-87CBCF2211C9@example.com>",
                  subject: "Example subject"
                }
              }
            },
            eventSource: "aws:ses"
          }
        ]
      }
    end

    it "responds with the mapped JSON" do
      post "/ses_events/transform",
           params: valid_payload,
           as: :json

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)

      json_response.each do |response|
        expect(response.keys).to match_array(
          %w[spam virus dns month delayed transmitter receiver]
        )
        expect(response["spam"]).to eq(true)
        expect(response["virus"]).to eq(true)
      end
      # etc. for each key
    end
  end
end
