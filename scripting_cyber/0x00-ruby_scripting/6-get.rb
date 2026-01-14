#!/usr/bin/env ruby

# Import the net/http library for making HTTP requests
require 'net/http'
require 'uri'
require 'json'

# Function to perform an HTTP GET request
def get_request(url)
  # Parse the URL string into a URI object
  uri = URI(url)

  # Create an HTTP GET request object
  http = Net::HTTP.new(uri.host, uri.port)

  # If the URL uses HTTPS, enable SSL
  http.use_ssl = true if uri.scheme == 'https'

  # Perform the GET request
  response = http.get(uri.path)

  # Extract the status code and convert to string (e.g., 200 -> "200")
  status_code = response.code

  # Extract the reason phrase (e.g., "OK", "Not Found")
  reason_phrase = response.message

  # Print the response status
  puts "Response status: #{status_code} #{reason_phrase}"

  # Print the response body
  puts "\nResponse body:\n"

  # Pretty print the JSON response for better readability
  parsed_body = JSON.parse(response.body)
  puts JSON.pretty_generate(parsed_body)
end
