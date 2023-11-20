require 'sequel'
require 'sequel/extensions/migration'
require 'dotenv'
Dotenv.load

require 'rake'
require_relative 'config/clickhouse'

namespace :db do
  desc 'Create the database'
  task :create do
    DB = Sequel.connect("mysql2://#{ENV['DB_USERNAME']}:#{ENV['DB_PASSWORD']}@#{ENV['DB_HOST']}")
    %w[ip_watcher_db_development ip_watcher_db_test].each do |db_name|
      DB.run "CREATE DATABASE IF NOT EXISTS `#{db_name}`;"
      puts "Database #{db_name} created."
    end
  end

  desc 'Migrate the database'
  task :migrate do
    %w[ip_watcher_db_development ip_watcher_db_test].each do |db_name|
      Sequel.connect("mysql2://#{ENV['DB_USERNAME']}:#{ENV['DB_PASSWORD']}@#{ENV['DB_HOST']}/#{db_name}") do |db|
        Sequel::Migrator.run(db, 'migrations')
        puts "Migrations are done."
    end
    end
  end
end

namespace :click_house do
  desc 'Migrate the clickhouse'
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
