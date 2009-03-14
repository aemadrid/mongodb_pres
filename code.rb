require 'rubygems'
require 'mongo'
require 'mongo/gridfs'

include XGen::Mongo
include XGen::Mongo::Driver
include XGen::Mongo::GridFS

puts "Let's connect to our server..."
db = Mongo.new(ENV['MONGO_RUBY_DRIVER_HOST']).db('mwrc')
contacts = db.collection('contacts')

puts "\nClearing old data..."
contacts.clear

puts "\nInserting John Smith data..."
puts contacts.insert('_id' => 1,
  'name' => "John Smith", 
  'age' => 35, 
  'balance' => 350.95,
  'address' => {
    'street' => "123 East River",
    'city' => "Sandy",
    'state' => "UT",
    'zip' => '12345-6789'
  },
  'music' => [ 'rock', 'jazz', 'new age' ]).inspect

puts "\nInserting Robert Stone data..."
puts contacts.insert('_id' => 2,
  'name' => "Robert Stone", 
  'age' => 27, 
  'balance' => 157.84,
  'address' => {
    'street' => "456 N Lake",
    'city' => "Boise",
    'state' => "ID",
    'zip' => '12345-6789'
  },
  'music' => [ 'punk', 'alternative', 'elevator' ]).inspect

puts "\nInserting Mark Rodgers data..."
puts contacts.insert('_id' => 3,
  'name' => "Mark Rodgers", 
  'age' => 35, 
  'balance' => 387.56,
  'address' => {
    'street' => "789 W Mountain",
    'city' => "Star Valley",
    'state' => "WY",
    'zip' => '12345-6789'
  },
  'music' => [ 'rock', 'jazz', 'ethnic' ]).inspect

puts "\nInserting common Ruby objects..."
puts contacts.insert('_id' => 4,
  'string' => 'hello',
  'array' => [1, 2, 3], 
  'hash' => {'a' => 1, 'b' => 2}, 
  'date' => Time.now, 
  'int' => 42,
  'float' => 33.33333, 
  'regex' => /foobar/i, 
  'boolean' => true, 
  'null' => nil,
  'symbol' => :zildjian).inspect

puts "\nCreating index on name and age..."  
contacts.create_index [ ['name', DESCENDING], ['age', ASCENDING] ]

puts "\nFinding people with age 35..."
puts contacts.find('age' => 35).map {|x| "[ %-20.20s | %3i ]" % [x['name'], x['age']]}.join("\n")

puts "\nFinding people with names ending in 'Smith'..."
puts contacts.find('name' => / Smith$/).map {|x| "[ %-20.20s ]" % x['name']}.join("\n")

puts "\nFinding people with a balance between $300 and $400..."
puts contacts.find('balance' => { '$gt' => 300.0, '$lte' => 400.0 }).map {|x| "[ %-20.20s | %06.2f ]" % [x['name'], x['balance']]}.join("\n")

puts "\nFinding people that like ethnic or punk music..."
puts contacts.find('music' => { '$in' => ['punk', 'ethnic'] }).map {|x| "[ %-20.20s | %-30.30s ]" % [x['name'], x['music'].join(', ')]}.join("\n")

puts "\nFinding people that live in Idaho or Utah..."
puts contacts.find('address.state' => { '$in' => ['ID', 'UT'] }).map {|x| "[ %-20.20s | %2s ]" % [x['name'], x['address']['state']]}.join("\n")

puts "\nFinding the youngest contact..."
puts contacts.find({ 'age' => { '$gt' => 0 }}, { :limit => 1, :sort => 'age' }).map {|x| "[ %-20.20s | %3i ]" % [x['name'], x['age']]}.join("\n")

puts "\nLet's write our own 'Hello, world!' file..."
GridStore.open(db, 'foobar', 'w') { |f| f.puts "Hello, world!" }
puts "Let's read it now..."
GridStore.open(db, 'foobar', 'r') { |f| puts f.read }
puts "Let's add some more text to this file..."
GridStore.open(db, 'foobar', 'w+') { |f| f.puts "But wait, there's more!" }
puts "Let's read it now, again..."
GridStore.open(db, 'foobar', 'r') { |f| puts f.read }

puts "File 'foobar' exists: #{GridStore.exist?(db, 'foobar')}"
puts "File 'does-not-exist' exists: #{GridStore.exist?(db, 'does-not-exist')}"

puts "\nThat's all folks!"