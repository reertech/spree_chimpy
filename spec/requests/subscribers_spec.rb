require 'spec_helper'

describe 'Subscribers' do

  context 'with valid subscription' do
    it 'redirects to referer' do
      post '/subscribers',
           params: { chimpy_subscriber: { email: 'foo2@bar.com', subscribed: true } },
           headers: { 'Referer' => 'http://foo.bar' }
      expect(response).to be_redirect
      expect(response.location).to eq('http://foo.bar')
    end

    it 'redirects to root URL if no referer' do
      post '/subscribers', params: {
        chimpy_subscriber: { email: 'foo2@bar.com', subscribed: true },
        referer: nil
      }

      expect(response).to be_redirect
      expect(response.location).to eq('http://www.example.com/')
    end
  end

  context 'with json response' do
    it 'returns 200 with json data' do
      headers = { "Accept" => "application/json" }
      post '/subscribers', params: { chimpy_subscriber: { email: 'foo2@bar.com', subscribed: true } }, headers: headers

      expect(response).to be_success
      json_response = JSON.parse(response.body)
      expect(json_response['email']).to eq('foo2@bar.com')
    end
  end
end
