#!/usr/bin/env ruby

#
# get_entities.rb
#
# Retrieves entities from the Ingress Intel API - https://www.ingress.com/r/getEntities
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

# ENV["http_proxy"] = "https://127.0.0.1:8888"

# Global variables
$version = "3372ba001844bd4a42680f3e6a2372d2490580f9"
$referer = "https://www.ingress.com/intel"
base_url = "https://www.ingress.com/r"
$uri = URI.parse("#{base_url}/getEntities")
$output_folder = "tiles"

test_tile = "16_6675_12158_0_8_100"

def fetch_tile(tile_key)
  puts "Downloading data for tile #{tile_key}"

  http = Net::HTTP.new($uri.host, $uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Post.new($uri.request_uri)

  post_body = []
  post_body << "{"
  post_body << %Q<"tileKeys":["#{tile_key}"],>
  post_body << %Q<"v":"#{$version}">
  post_body << "}"
  # puts "post_body: #{post_body.join}"

  request.body = post_body.join
  request["Referer"] = $referer

  private_data = YAML.load_file('private.yml')
  puts private_data

  private_data["Headers"].each do |key, value|
    request[key] = value
  end

  cookies = ""
  private_data["Cookies"].each do |key, value|
    cookies += "#{key}=#{value};"
  end
  request["Cookie"] = cookies
  # puts cookies
  # puts request

  response = http.request(request)
  puts response.class.name + " " + response.code
  puts "Set-Cookie: " + response.get_fields('set-cookie').to_s
  puts ""
  puts response.body

  FileUtils::mkdir_p $output_folder
  File.open("#{$output_folder}/#{tile_key}.json", 'w') {|file| file.write(response.body) }
end

#
# Parse arguments, build array of tile keys and fetch each one.
#

tiles_to_download = []

ARGV.each do |arg|
  puts "Argument: #{arg}"
  tiles_to_download << arg
end

if tiles_to_download.to_a.empty?
  tiles_to_download << test_tile
end

tiles_to_download.each do |tile|
  fetch_tile(tile)
end
