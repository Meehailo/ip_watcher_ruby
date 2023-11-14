require 'rufus-scheduler'
require_relative 'app'

scheduler = Rufus::Scheduler.new

scheduler.cron '* * * * *' do
  PingIpJob.perform
end

scheduler.join
