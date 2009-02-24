require 'rubygems'
require 'mongo'
require 'sequel'

# Connect to Mongo
host = ENV['MONGO_RUBY_DRIVER_HOST'] || 'localhost'
port = ENV['MONGO_RUBY_DRIVER_PORT'] || XGen::Mongo::Driver::Mongo::DEFAULT_PORT
unam = ENV['MONGO_RUBY_DRIVER_USER'] || 'ruby-mongo-pres'
pswd = ENV['MONGO_RUBY_DRIVER_PSWD'] || 'remongo'
dbnm = ENV['MONGO_RUBY_DRIVER_DB']   || 'ruby-mongo-pres'

puts "MONGO: Connecting to #{host}:#{port} (CONN) on with database #{dbnm} (DB)"
MCONN = XGen::Mongo::Driver::Mongo.new(host, port)
M = MCONN.db(dbnm)

# Connect to MySQL
host = ENV['MYSQL_HOST'] || 'localhost'
port = ENV['MYSQL_PORT'] || 3306
unam = ENV['MYSQL_USER'] || 'ruby-mongo-pres'
pswd = ENV['MYSQL_PSWD'] || 'remongo'
dbnm = ENV['MYSQL_DB']   || 'ruby-mongo-pres'

puts "MySQL: Connecting to #{host}:#{port} (CONN) on with database #{dbnm} (DB)"
Y = Sequel.mysql(dbnm, :user => unam, :password => pswd, :host => host, :port => port)


