require 'rubygems'
require 'mongo'
require 'sequel'

# Connect to Mongo
host = ENV['MONGO_RUBY_DRIVER_HOST'] || 'localhost'
port = ENV['MONGO_RUBY_DRIVER_PORT'].to_i || 27017
unam = ENV['MONGO_RUBY_DRIVER_USER'] || 'ruby-mongo-pres'
pswd = ENV['MONGO_RUBY_DRIVER_PSWD'] || 'remongo'
dbnm = ENV['MONGO_RUBY_DRIVER_DB']   || 'ruby-mongo-pres'

puts "MONGO: Connecting to #{host}:#{port} with database #{dbnm} (DB) and table 'hits' (mh)"
MCONN = XGen::Mongo::Driver::Mongo.new(host, port)
MDB = MCONN.db(dbnm)
MHITS = MDB.collection 'hits'
MHITS.create_index 'main', 'site_id', 'page_id', 'page_url'
# Mongo does not create the collection until something is there
# MHITS << { 'no_field_name' => 1 }
# MHITS.remove 'no_field_name' => 1
def mhits() MHITS end
alias :mh :mhits

# Connect to MySQL
host = ENV['MYSQL_HOST'] || 'localhost'
port = ENV['MYSQL_PORT'].to_i || 3306
unam = ENV['MYSQL_USER'] || 'ruby-mongo-pres'
pswd = ENV['MYSQL_PSWD'] || 'remongo'
dbnm = ENV['MYSQL_DB']   || 'ruby-mongo-pres'

puts "MySQL: Connecting to #{host}:#{port} with database #{dbnm} (DB) and table 'hits' (yh)"
YDB = Sequel.mysql(dbnm, :user => unam, :password => pswd, :host => host, :port => port)
YHITS = YDB[:hits]
def yhits() YHITS end
alias :yh :yhits
