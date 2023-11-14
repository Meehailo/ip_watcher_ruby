require 'sequel'
require 'rake'
require 'sequel/extensions/migration'
require 'dotenv'
require 'config/database'
Dotenv.load

namespace :db do
  desc "Migrate the database"
  task :migrate do
    Sequel::Migrator.run(DB, 'migrations')
    puts "Migrations are done."
  end
end
