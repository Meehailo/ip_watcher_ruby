require 'clickhouse'

Clickhouse.establish_connection(url: ENV['CLICKHOUSE_DB_URL'])
