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

def parse_tile(tile_key)
  puts "Extracting data from tile #{tile_key}"

  File.open("#{$input_folder}/#{tile_key}.json", 'r') { |file|
    contents = file.read()
    puts contents
  }

  # private_data["Cookies"].each do |key, value|
  #   cookies += "#{key}=#{value};"
  # end

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
