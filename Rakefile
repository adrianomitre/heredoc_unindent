# -*- ruby -*-

require 'rubygems'
require 'hoe'

Hoe.spec 'heredoc_unindent' do
  developer('Adriano Mitre', 'adriano.mitre@gmail.com')
  
  self.version = '1.2.0'
  
  self.readme_file = 'README.rdoc'
  self.history_file = 'History.rdoc'
  self.extra_rdoc_files += ['README.rdoc', 'History.rdoc']

  # self.rubyforge_name = 'heredoc_unindentx' # if different than 'heredoc_unindent'
end

# vim: syntax=ruby

task :tests => [:test] do
  # aliasing :test with :tests for RVM ('rvm tests')
end

task :clean_all => [:clean] do
  rm_rf '.yardoc/'
end
