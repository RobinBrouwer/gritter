namespace :gritter do
  desc 'Install the gritter sources'
  task :install => :environment do
    Gritter.install_gritter
  end
end