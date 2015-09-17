require 'raven'

Raven.configure do |config|
  config.dsn = 'https://77dcd1573c8d4783a790a75f7a065052:e2263102c30a457b8e2631d654552094@app.getsentry.com/46436'
  config.environments = %w[ production ]
  config.excluded_exceptions = ['FetchMetaJob::LinkPageUnavailable']
end