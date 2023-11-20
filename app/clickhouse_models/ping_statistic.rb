class PingStatistic
  def self.statistic(ip, time_from, time_to)
    return [] if ip.nil?

    sql = <<-SQL
      SELECT 
        ip_address,
        AVG(rtt),
        MIN(rtt),
        MAX(rtt),
        quantile(0.5)(rtt),
        stddevPop(rtt),
        (countIf(ping_status = 0) / count()) * 100
      FROM ping_statistics
      WHERE ip_address = '#{ip}'
    SQL
    sql += " AND timestamp >= '#{time_from}'" if time_from
    sql += " AND timestamp <= '#{time_to}'" if time_to
    sql += " GROUP BY ip_address"

    result = Clickhouse.connection.execute(sql)
    return result.chomp.split("\t") if result.is_a?(String)

    []
  end
end
