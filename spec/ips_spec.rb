require 'spec_helper'

RSpec.describe 'POST /ips', type: :request do
  context 'with valid parameters' do
    let(:valid_params) { { address: '192.168.0.1', enabled: true } }
    let(:valid_params_ipv6) { { address: '2001:0db8:85a3:0000:0000:8a2e:0370:7334', enabled: true } }

    it 'creates a new IP' do
      post '/ips', valid_params
      json_response = JSON.parse(last_response.body)
      expect(last_response.status).to eq(201)
      expect(json_response['result'].has_key?('id'))
      expect(json_response['result'].has_key?('address'))
      expect(json_response['result'].has_key?('enabled'))
      expect(json_response['result'].has_key?('ip_version'))
      expect(json_response['result']['ip_version']).to eq('ipv4')
    end

    it 'creates a new IPv6' do
      post '/ips', valid_params_ipv6
      json_response = JSON.parse(last_response.body)
      expect(last_response.status).to eq(201)
      expect(json_response['result']['ip_version']).to eq('ipv6')
    end
  end

  context 'with invalid parameters' do
    let(:invalid_params) { { address: 'invalid-ip', enabled: true } }

    it 'returns an error' do
      post '/ips', invalid_params
      expect(last_response.status).to eq(422)
    end
  end
end

RSpec.describe 'POST /ips/:id/enable', type: :request do
  context 'when IP exists' do
    let(:ip) { Ip.create(address: '192.168.0.1', enabled: false) }

    it 'enables the IP' do
      post "/ips/#{ip.id}/enable"
      expect(last_response.status).to eq(202)
    end
  end

  context 'when IP does not exist' do
    it 'returns not found' do
      post "/ips/non_existing_id/enable"
      expect(last_response.status).to eq(404)
    end
  end
end

RSpec.describe 'GET /ips/:id/stats', type: :request do
  context 'when IP exists' do
    # TODO: найти какие-то решения для предзаполнения кликхауса тестовыми данными либо писать запросы

    # let(:ip) { Ip.create(address: '192.168.0.1', enabled: true) }

    # it 'returns statistics' do
    #   get "/ips/#{ip.id}/stats"
    #   expect(last_response.status).to eq(200)
    # end
  end

  context 'when IP does not exist' do
    it 'returns not found' do
      get "/ips/non_existing_id/stats"
      expect(last_response.status).to eq(404)
    end
  end
end

RSpec.describe 'DELETE /ips/:id', type: :request do
  context 'when IP exists' do
    let(:ip) { Ip.create(address: '192.168.0.1', enabled: true) }

    it 'deletes the IP' do
      delete "/ips/#{ip.id}"
      expect(last_response.status).to eq(204)
    end
  end
end
