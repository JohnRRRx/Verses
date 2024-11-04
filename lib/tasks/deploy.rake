namespace :deploy do
    task :precompile do
      ENV['PRECOMPILE'] = 'true'
      ENV['SPOTIFY_CLIENT_ID'] = 'dummy'
      ENV['SPOTIFY_SECRET_ID'] = 'dummy'
      Rake::Task['assets:precompile'].invoke
    end
  end