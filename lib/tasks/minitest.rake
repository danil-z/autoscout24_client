require "rake/testtask"

#Rake::TestTask.new(:test => "db:test:prepare") do |t|
#Rake::TestTask.new() do |t|
#  t.libs << "test"
#  t.pattern = "test/**/*_test.rb"
#end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
end
task :default => :test