#!/bin/ruby

require 'json'
require 'stringio'

# Complete the arrayManipulation function below.
def arrayManipulation(n, queries)
    values = Array.new(n+1, 0)
    
    queries.each do |a, b, k|
        values[a] += k
        values[b+1] -= k if b < n
    end

    max = 0
    currentVal = 0
    values.each do |val|
        currentVal += val
        max = currentVal if currentVal > max
    end
    
    return max
end

n, m = 0, 0
firstLine = true
queries = nil
File.readlines(ARGV[0]).each do |line|
    if firstLine
	firstLine = false
	n, m = line.split(' ').map(&:to_i)
	queries = []
    else
        queries.push line.split(' ').map(&:to_i)
    end    
end

result = arrayManipulation n, queries

puts "Success: #{File.read(ARGV[1]).to_i == result}"

