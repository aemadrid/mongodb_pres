#!/usr/bin/env ruby
require 'connection'

puts "Clearing hits collection on mongo"
mh.clear()

puts "Clearing hits table on mysql"
YDB << "DROP TABLE hits"
YDB << "CREATE TABLE `hits` (  
  `id` int(11) NOT NULL auto_increment,
  `site_id` int(11) default NULL,
  `page_id` int(11) default NULL,
  `page_url` varchar(255) default NULL,
  `request_url` varchar(255) default NULL,
  `track_network` varchar(255) default NULL,
  `track_campaign` varchar(255) default NULL,
  `track_offer` varchar(255) default NULL,
  `track_id` varchar(255) default NULL,
  `track_ip` varchar(255) default NULL,
  `track_referer` varchar(255) default NULL,
  `session_id` int(11) default NULL,
  `process_time` varchar(255) default NULL,
  `server_name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `main` (`site_id`,`page_id`,`page_url`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8"
