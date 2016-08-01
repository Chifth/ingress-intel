#!/usr/bin/env ruby

#
# parse_entities.rb
#
# Parses entities downloaded in JSON from the Ingress Intel API - https://www.ingress.com/r/getEntities
#
# Provide one or more tile keys as arguments to this script.
# When executed without arguments, uses a default tile key for testing.
#

require 'net/https'
require 'uri'
require 'rubygems'
require 'json'
require 'FileUtils'
require 'yaml'

# Global variables
$input_folder = "tiles"
$output_folder = "portals"

test_tile = "16_4968_12056_0_8_100"

class Portal
  attr_accessor :key, :id, :name, :faction, :imageUrl, :latitude, :longitude
end

def parse_tile(tile_key)
  puts "Extracting data from tile #{tile_key}"

  contents = ""
  File.open("#{$input_folder}/#{tile_key}.json", 'r') { |file|
    contents = file.read()
  }
  json = JSON(contents)
  entities = json['result']['map'][tile_key]['gameEntities']

  entities.each do |entity_array|
    key = entity_array[0]

    # part after period indicates enty type?
    # - 9
    # - 12
    # - 16 - portal
    # - b
    # - b_ab
    # - b_ac

    # Only working with portals right now
    next if !key.end_with?('.16')

    id = entity_array[1]
    data_array = entity_array[2]
    # 8 values - line between two portals?
    # 3 values - field between three portals?
    # 14 values - unlinked portal

    puts "#{key} - #{data_array}"
  end

  # FileUtils::mkdir_p $output_folder
  # File.open("#{$output_folder}/#{tile_key}.json", 'w') {|file| file.write(response.body) }
end

#
# Parse arguments, build array of tile keys and parse each one.
#

tiles_to_parse = []

ARGV.each do |arg|
  puts "Argument: #{arg}"
  tiles_to_parse << arg
end

if tiles_to_parse.to_a.empty?
  tiles_to_parse << test_tile
end

tiles_to_parse.each do |tile|
  parse_tile(tile)
end
