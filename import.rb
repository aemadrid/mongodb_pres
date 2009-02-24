#!/usr/bin/env ruby
require 'connection'
require 'fastercsv'

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
end

# Just process the csv file
t0 = Time.now
process_hits(max) {|row|  } # puts row.inspect
t1 = Time.now - t0
puts "Took #{t1} to process the csv file..."


# Add 
t2 = Time.now
process_hits {|row| }
t3 = Time.now - t2
puts "Took #{t3} to process the csv file..."

# 
# # Just process the csv file
# t0 = Time.now
# process_hits {|row| }
# t1 = Time.now - t0
# puts "Took #{t1} to process the csv file..."