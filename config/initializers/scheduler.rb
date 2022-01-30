# don't run when in a console, in a test, or in a rake task
return if defined?(Rails::Console) || Rails.env.test? || File.split($PROGRAM_NAME).last == 'rake'

scheduler = Rufus::Scheduler.singleton

scheduler.every '10s' do
  SatelliteDataRetrievalJob.perform_later
end