namespace :ci do
  desc "Prepare for CI and run entire test suite"
  task :build do
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:test:prepare'].invoke
    Rake::Task['test:units'].invoke
  end

  task :deploy do
    # sh "cap staging deploy"
  end

  desc "Prepare for CI and run entire test suite"
  task :run => ['ci:build'] do

  end

end
