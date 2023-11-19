class PingIpJob
  require 'net/ping'

  def self.perform
    results = []
    Ip.where(enabled: true).each do |ip|
      ping = Net::Ping::External.new(ip.address, nil, 1) # таймаут 1 сек
      result_data = {
        ip_address: ip.address,
        ping_status: ping.ping? ? 1 : 0,
        rtt: ping.duration || 0.0,
        timestamp: Time.now
      }
      results << result_data
    end

    results.each do |result|
      sql = <<-SQL
        INSERT INTO ping_statistics (ip_address, ping_status, rtt, timestamp)
        VALUES ('#{result[:ip_address]}', #{result[:ping_status]}, #{result[:rtt]}, '#{result[:timestamp].strftime('%Y-%m-%d %H:%M:%S')}')
      SQL

      Clickhouse.connection.execute(sql)
    end
  end
end
