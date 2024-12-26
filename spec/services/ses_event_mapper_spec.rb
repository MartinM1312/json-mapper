# spec/services/ses_event_mapper_spec.rb
require 'rails_helper'

RSpec.describe SesEventMapper, type: :service do
  describe '.call' do
    let(:input_json) do
      {
        "Records" => [
          {
            "eventVersion" => "1.0",
            "ses" => {
              "receipt" => {
                "timestamp" => "2015-09-11T20:32:33.936Z",
                "processingTimeMillis" => 222,
                "recipients" => [
                  "recipient@example.com"
                ],
                "spamVerdict" => { "status" => "PASS" },
                "virusVerdict" => { "status" => "PASS" },
                "spfVerdict"   => { "status" => "PASS" },
                "dkimVerdict"  => { "status" => "PASS" },
                "dmarcVerdict" => { "status" => "PASS" },
                "dmarcPolicy"  => "reject",
                "action" => {
                  "type" => "SNS",
                  "topicArn" => "arn:aws:sns:us-east-1:012345678912:example-topic"
                }
              },
              "mail" => {
                "timestamp" => "2015-09-11T20:32:33.936Z",
                "source" => "61967230-7A45-4A9D-BEC9-87CBCF2211C9@example.com",
                "messageId" => "d6iitobk75ur44p8kdnnp7g2n800",
                "destination" => [
                  "recipient@example.com"
                ],
                "headersTruncated" => false,
                "headers" => [
                  {
                    "name" => "From",
                    "value" => "sender@example.com"
                  }
                ],
                "commonHeaders" => {
                  "returnPath" => "0000014fbe1c09cf-7cb9f704-7531-4e53-89a1-5fa9744f5eb6-000000@amazonses.com",
                  "from" => [ "sender@example.com" ],
                  "date" => "Fri, 11 Sep 2015 20:32:32 +0000",
                  "to" => [ "recipient@example.com" ],
                  "messageId" => "<61967230-7A45-4A9D-BEC9-87CBCF2211C9@example.com>",
                  "subject" => "Example subject"
                }
              }
            },
            "eventSource" => "aws:ses"
          }
        ]
      }
    end

    subject(:mapped_result) { SesEventMapper.call(input_json) }

    it 'returns a hash with the expected keys' do
      mapped_result.each do |result|
        expect(result).to be_a(Hash)
        expect(result.keys).to contain_exactly(
          :spam, :virus, :dns, :month, :delayed, :transmitter, :receiver
        )
      end
    end

    it 'maps spam verdict to true if status is PASS' do
      mapped_result.each do |result|
        expect(result[:spam]).to eq(true)
      end
    end

    it 'maps virus verdict to true if status is PASS' do
      mapped_result.each do |result|
        expect(result[:virus]).to eq(true)
      end
    end

    it 'maps dns to true if spf/dkim/dmarc are all PASS' do
      mapped_result.each do |result|
        expect(result[:dns]).to eq(true)
      end
    end

    it 'extracts the month from mail.timestamp' do
      mapped_result.each do |result|
        expect(result[:month]).to eq('September')
      end
    end

    it 'marks delayed as false if processingTimeMillis <= 1000' do
      mapped_result.each do |result|
        expect(result[:delayed]).to eq(false)
      end
    end

    it 'extracts emisor as the local part of mail.source' do
      mapped_result.each do |result|
        expect(result[:transmitter]).to eq('61967230-7A45-4A9D-BEC9-87CBCF2211C9')
      end
    end

    it 'extracts receptor as an array of local parts from mail.destination' do
      mapped_result.each do |result|
        expect(result[:receiver]).to eq([ "recipient" ])
      end
    end
  end
end
