require 'sequel'

DB = Sequel.connect("mysql2://#{ENV['DB_USERNAME']}:#{ENV['DB_PASSWORD']}@#{ENV['DB_HOST']}/#{ENV['DB_NAME']}")