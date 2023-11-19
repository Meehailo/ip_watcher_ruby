require 'sequel'
require 'dotenv'
Dotenv.load

require 'rake'
require_relative 'config/database'
require_relative 'config/clickhouse'

namespace :db do
  desc "Migrate the database"
  task :migrate do
    Sequel::Migrator.run(DB, 'migrations')
    puts "Migrations are done."
  end
end

namespace :click_house do
  desc "Migrate the clickhouse"
  task :create_ping_statistics do
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS ping_statistics (
        ip_address String,
        rtt Float64,
        ping_status UInt8,
        timestamp DateTime
      ) ENGINE = MergeTree()
      ORDER BY (ip_address, timestamp)
    SQL

    Clickhouse.connection.execute(sql)
  end
end
