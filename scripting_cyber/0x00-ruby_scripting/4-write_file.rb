#!/usr/bin/env ruby

# Import json module to read, parse and write JSON files
require 'json'

def merge_json_files(file1_path, file2_path)
  # Read and parse the first JSON file into a Ruby array/hash
  data1 = JSON.parse(File.read(file1_path))

  # Read and parse the second JSON file into a Ruby array/hash
  data2 = JSON.parse(File.read(file2_path))

  # Merge the two arrays (data2 first, then data1)
  merged_data = data2 + data1

  # Open file2 in write mode ('w' = overwrite)
  File.open(file2_path, 'w') do |f|
    # Write the merged data as formatted JSON (with indentation)
    f.write(JSON.pretty_generate(merged_data))
  end

  # Display confirmation message
  puts "Merged JSON written to #{file2_path}"
end
