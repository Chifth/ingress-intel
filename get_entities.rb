#!/usr/bin/env ruby

#
# get_entities.rb
#
# Retrieves entities from the Ingress Intel API - https://www.ingress.com/r/getEntities
#

require 'net/https'
require 'uri'
require 'rubygems'
require 'json'
require 'FileUtils'
require 'yaml'

# ENV["http_proxy"] = "https://127.0.0.1:8888"

def fetch_tile(tile_key)
  puts "Downloading data for tile #{tile_key}"

  uri = URI.parse("https://www.ingress.com/r/getEntities")
  referer = "https://www.ingress.com/intel"

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Post.new(uri.request_uri)

  post_body = []
  post_body << "{"
  post_body << %Q<"tileKeys":["#{tile_key}"],>
  post_body << %Q<"v":"3372ba001844bd4a42680f3e6a2372d2490580f9">
  post_body << "}"
  # puts "post_body: #{post_body.join}"

  request.body = post_body.join
  request["Referer"] = referer

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

  # json = JSON.parse(response.body)[0]
end

fetch_tile("16_6675_12158_0_8_100")
