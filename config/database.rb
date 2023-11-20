require 'sequel'

# TODO: доработать для других окружений
db_name = ENV['DB_NAME']
db_name += ENV['SINATRA_ENV'] == 'test' ? '_test' : '_development'
DB = Sequel.connect("mysql2://#{ENV['DB_USERNAME']}:#{ENV['DB_PASSWORD']}@#{ENV['DB_HOST']}/#{db_name}")
