#!/usr/bin/env ruby
require 'connection'
require 'fastercsv'
require 'yaml'

puts "Loading data..."
data = YAML::load_file('data.yml') rescue Hash.new
  
max = ARGV[0] || 'all'
puts "Processing #{max} records..."

def process_hits(max, &block)
  all = max == 'all'
  max = max.to_i
  cnt = 0
  fields = [ :site_id, :page_id, :page_url, :request_url, :track_network, :track_campaign, :track_offer, :track_id, 
             :track_ip, :track_referer, :session_id, :process_time, :server_name, :created_at ]
  FasterCSV.foreach('hits.csv') do |row|
    hsh = {}
    fields.each_with_index {|name, idx| hsh[name] = row[idx]}
    yield hsh 
    cnt += 1
    break if !all && cnt == max
  end
  return cnt
end

def timeit(rt = 0)
  st = Time.now
  res = yield
  [ res, Time.now - st - rt ]
end

# Just process the csv file
res, pt = timeit(0) do
  process_hits(max) {|hsh|  } # puts row.hsh
end
puts "Took %5.2f seconds to process %i records in the csv file..." % [pt, res]


# MySQL
res, yt = timeit(pt) do
  process_hits(max) {|hsh| yh.insert hsh }
end
puts "Took %5.2f seconds to add %i MySQL..." % [yt, res]

# Mongo
res, mt = timeit(pt) do
  process_hits(max) {|hsh| mh << hsh }
end
puts "Took %5.2f seconds to add %i MySQL..." % [mt, res]

data[res] = { :csv => pt, :mysql => yt, :mongo => mt }

puts "Saving data..."
File.open('data.yml', 'w') {|out| YAML.dump(data, out) }

puts "DATA\n#{data.to_yaml}"