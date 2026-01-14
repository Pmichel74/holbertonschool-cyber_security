#!/usr/bin/env ruby

# import json module
require 'json'

def count_user_ids(path)
    # read and parse json
    file.content = File.read(path)
    data = JSON.parse(file_content)
    