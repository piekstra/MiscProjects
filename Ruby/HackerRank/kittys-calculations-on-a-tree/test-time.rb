iters = 1000000

start = Time.now
arr = Array.new(1000000, 69)
i = 0
iters.times do
    arr[i] += 1
    i += 1
end
puts Time.now - start

start = Time.now
h = {}
i = 0
iters.times do
    h[i] = i
    i += 1
end
puts Time.now - start
