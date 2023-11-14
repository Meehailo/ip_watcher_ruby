require 'sinatra/base'
require 'sequel'
require 'dotenv'
require 'byebug'
require 'json'
require 'sinatra/strong-params'
Dotenv.load
require_relative 'config/database'

Dir[File.join(File.dirname(__FILE__), 'app/models', '*.rb')].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), 'app/routes', '*.rb')].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), 'jobs', '*.rb')].each { |file| require file }

class App < Sinatra::Application
  use Ips

  run! if app_file == $0
end
