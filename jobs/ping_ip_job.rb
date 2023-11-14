class PingIpJob
  require 'net/ping'

  def self.perform
    Ip.where(enabled: true).each do |ip|
      ping = Net::Ping::External.new(ip.address)
      if ping.ping?
        puts "Пинг успешен. Время отклика: #{ping.duration} сек."
      else
        puts "Пинг не удался. Причина: #{ping.exception}"
      end
    end
  end
end
