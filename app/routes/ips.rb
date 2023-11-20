class Ips < Sinatra::Application
  register Sinatra::StrongParams

  # - добавить адрес с параметрами (enabled: bool, ip: ipv4/ipv6 address)
  post '/ips', allows: [:address, :enabled] do
    ip = Ip.new(params)

    if ip.valid?
      ip.save
      status 201
      content_type :json
      { result: ip.values }.to_json
    else
      status 422
      content_type :json
      { error: ip.errors.full_messages }.to_json
    end
  rescue Sequel::UniqueConstraintViolation => e
    status 422
    content_type :json
    { error: e.message }.to_json
  end

  # - включить сбор статистики ip
  post '/ips/:id/enable' do
    ip = Ip.where(id: params[:id]).first
    if ip.nil?
      status 404
      content_type :json
      { error: 'not found' }.to_json
    else
      ip.update(enabled: true)
      status 202
      content_type :json
      { result: ip.values }.to_json
    end
  end

  # - выключить сбор статистики ip
  post '/ips/:id/disable' do
    ip = Ip.where(id: params[:id]).first
    if ip.nil?
      status 404
      content_type :json
      { error: 'not found' }.to_json
    else
      ip.update(enabled: false)
      status 202
      content_type :json
      { result: ip.values }.to_json
    end
  end

  #  - получить статистику для адреса (time_from: datetime, time_to: datetime)
  get '/ips/:id/stats', allows: [:time_from, :time_to, :id] do
    ip = Ip.where(id: params[:id]).first
    result = PingStatistic.statistic(ip&.address, params[:time_from], params[:time_to])

    unless result.empty?
      result = PingStatistic.statistic(ip.address, params[:time_from], params[:time_to])

      status 200
      content_type :json
      { result: {
                  ip_address: result[0],
                  avg_rtt: result[1],
                  min_rtt: result[2],
                  max_rtt: result[3],
                  median_rtt: result[4],
                  stddev_rtt: result[5],
                  packet_loss_percent: result[6]
                }
      }.to_json
    else
      status 404
      content_type :json
      { error: 'not found' }.to_json
    end
  end

  #  - выключить сбор и удалить адрес
  delete '/ips/:id' do
    ip = Ip.where(id: params[:id]).first
    ip.destroy unless ip.nil?
    status 204
  end
end
