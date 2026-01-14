#!/usr/bin/env ruby

# Import the net/http library for making HTTP requests
require 'net/http'
require 'json'

# Function to perform an HTTP GET request
def get_request(url)
  # Parse the URL string into a URI object
  uri = URI(url)

  # Perform the GET request and get the response directly
  response = Net::HTTP.get_response(uri)

  # Extract the status code and reason phrase
  status_code = response.code
  reason_phrase = response.message

  # Print the response status
  puts "Response status: #{status_code} #{reason_phrase}"

  # Print the response body
  puts "\nResponse body:\n"

  # Pretty print the JSON response for better readability
  parsed_body = JSON.parse(response.body)
  puts JSON.pretty_generate(parsed_body)
end
