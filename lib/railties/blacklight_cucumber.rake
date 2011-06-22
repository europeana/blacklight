# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a 
# newer version of cucumber-rails. Consider adding your own code to a new file 
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.

# Blacklight customization, trick Cucumber into looking in our current
# location for Rails.root, even though we're going to give it features
# from elsewhere. 
ENV['RAILS_ROOT'] = Rails.root.to_s

# blacklight_features, where to find features inside blacklight source?
blacklight_features = File.expand_path("./test_support/features", Blacklight.root)

unless ARGV.any? {|a| a =~ /^gems/} # Don't load anything when running the gems:* tasks

vendored_cucumber_bin = Dir["#{Rails.root}/vendor/{gems,plugins}/cucumber*/bin/cucumber"].first
$LOAD_PATH.unshift(File.dirname(vendored_cucumber_bin) + '/../lib') unless vendored_cucumber_bin.nil?

begin
  require 'cucumber/rake/task'

  namespace :blacklight do
    namespace :cucumber do
      Cucumber::Rake::Task.new({:ok => 'db:test:prepare'}, 'Run features that should pass') do |t|
        # Blacklight customization, call features from external location, pass
        # in feature location wtih cucumber_opts, yeah it's weird but that's how.
        t.cucumber_opts = blacklight_features + " --format progress"
        
        t.binary = vendored_cucumber_bin # If nil, the gem's binary is used.
        t.fork = true # You may get faster startup if you set this to false
        t.profile = 'default'
      end

      Cucumber::Rake::Task.new({:wip => 'db:test:prepare'}, 'Run features that are being worked on') do |t|
        # Blacklight customization, call features from external location, pass
        # in feature location wtih cucumber_opts, yeah it's weird but that's how.
        t.cucumber_opts = blacklight_features
        
        
        t.binary = vendored_cucumber_bin
        t.fork = true # You may get faster startup if you set this to false
        t.profile = 'wip'
      end
  
      Cucumber::Rake::Task.new({:rerun => 'db:test:prepare'}, 'Record failing features and run only them if any exist') do |t|
        # Blacklight customization, call features from external location, pass
        # in feature location wtih cucumber_opts, yeah it's weird but that's how.
        t.cucumber_opts = blacklight_features
        
        t.binary = vendored_cucumber_bin
        t.fork = true # You may get faster startup if you set this to false
        t.profile = 'rerun'
      end

      if (RUBY_VERSION.to_f < 1.9)  then      
      Cucumber::Rake::Task.new({:rcov => 'db:test:prepare'}, 'Run features with rcov') do |t|
        # Blacklight customization, call features from external location, pass
        # in feature location wtih cucumber_opts, yeah it's weird but that's how.
        t.cucumber_opts = blacklight_features
        
        t.binary = vendored_cucumber_bin # If nil, the gem's binary is used.
        t.fork = true # You may get faster startup if you set this to false
        t.profile = 'default'
        t.rcov = true
        t.rcov_opts = %w{--rails --exclude osx\/objc,gems\/,spec\/,features\/ --aggregate blacklight-coverage.data}
        t.rcov_opts << %[-o "blacklight-coverage"]
      end
      end	
  
      desc 'Run all features'
      task :all => [:ok, :wip]
      
      
      # Solr wrapper. for now just for blacklight:cucumber, plan to
      # provide it for all variants eventually.
      # if you would like to see solr startup messages on STDERR
      # when starting solr test server during functional tests use:
      # 
      #    rake SOLR_CONSOLE=true
      require File.expand_path('../jetty_solr_server.rb', __FILE__)
      desc "blacklight:cucumber with jetty/solr launch"
      task :with_solr do      
        # wrap tests with a test-specific Solr server
        # Need to look  up where the test jetty is located
        # from solr.yml, we don't hardcode it anymore. 

        solr_yml_path = locate_path("config", "solr.yml")
        jetty_path = if ( File.exists?( solr_yml_path ))
            solr_config = YAML::load(File.open(solr_yml_path))
            solr_config["test"]["jetty_path"] if solr_config["test"]
        end   
        raise Exception.new("Can't find jetty path to start test jetty. Expect a jetty_path key in config/solr.yml for test environment.") unless jetty_path 
        
        JettySolrServer.new(
          :jetty_home => File.expand_path(jetty_path, Rails.root), 
          :sleep_after_start => 2).wrap do 
            Rake::Task["blacklight:cucumber"].invoke 
        end     
      end      
      
    end
    
    desc 'Alias for blacklight:cucumber:ok'
    task :cucumber => 'blacklight:cucumber:ok'
        
  end


  

  task :features => :cucumber do
    STDERR.puts "*** The 'features' task is deprecated. See rake -T cucumber ***"
  end

  # In case we don't have ActiveRecord, append a no-op task that we can depend upon.
  task 'db:test:prepare' do
  end
rescue LoadError
  desc 'cucumber rake task not available (cucumber not installed)'
  task :cucumber do
    abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
  end
end

end
