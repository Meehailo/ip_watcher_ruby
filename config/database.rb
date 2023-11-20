require 'sequel'

# TODO: доработать для других окружений
db_name = ENV['DB_NAME']
db_name += ENV['SINATRA_ENV'] == 'test' ? '_test' : '_development'

attempt_count = 0
max_attempts = 10
sleep_interval = 3

begin
  DB = Sequel.connect("mysql2://#{ENV['DB_USERNAME']}:#{ENV['DB_PASSWORD']}@#{ENV['DB_HOST']}/#{db_name}")
rescue Sequel::DatabaseConnectionError => e
  attempt_count += 1
  if attempt_count < max_attempts
    sleep sleep_interval
    retry
  else
    raise
  end
end
