#!/bin/ruby

require 'json'
require 'stringio'

n, m = 0, 0
firstLine = true
values = nil
File.readlines(ARGV[0]).each do |line|
    if firstLine
        firstLine = false
        n, m = line.split(' ').map(&:to_i)
        values = Array.new(n+1, 0)
        queries = []
    else
        a,b,k = line.split(' ').map(&:to_i)
        values[a] += k
        values[b+1] -= k if b < n
    end    
end

max = 0
currentVal = 0
values.each do |val|
    currentVal += val
    max = currentVal if currentVal > max
end

puts "Success: #{File.read(ARGV[1]).to_i == max}"

