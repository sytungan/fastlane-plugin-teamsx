require 'spec_helper'

describe Fastlane::Actions::TeamsXAction do
  it "sends an Adaptive Card with minimal parameters" do
    # Prepare test params
    params = {
      title: "Test Title",
      message: "Test Message",
      teams_url: "https://outlook.office.com/webhook/test"
    }

    # Mock Net::HTTP and response
    fake_response = double('response', code: '200', body: '1')
    fake_http = double('http')
    allow(fake_http).to receive(:use_ssl=)
    expect(fake_http).to receive(:post) do |path, body, headers|
      expect(path).to eq('/webhook/test')
      expect(headers['Content-Type']).to eq('application/json')
      json = JSON.parse(body)
      expect(json['type']).to eq('message')
      expect(json['attachments']).to be_an(Array)
      expect(json['attachments'][0]['contentType']).to eq('application/vnd.microsoft.card.adaptive')
      expect(json['attachments'][0]['content']['body'].any? { |b| b['text'] == 'Test Title' }).to be true
      fake_response
    end
    allow(Net::HTTP).to receive(:new).and_return(fake_http)

    # Run the action
    Fastlane::Actions::TeamsXAction.run(params)
  end
end
