require 'pp'

def computeQuery(k, vals, tree, distCache)
    result = 0
    iteration = 0
    (vals.sort!.combination 2).each do |c|
        a, b = c
        d = dist a, b, tree, distCache
        iteration += 1
        puts "solved #{iteration}"
        expression = quickMod(a) * quickMod(b) * quickMod(d)
        result += quickMod expression
    end

    return quickMod result
end

def dist(a, b, tree, distCache)
    ad, bd = 0,0
    as, bs = a, b
    while as != bs
        if as > bs
            as = tree[as]
            ad += 1
        end

        if as != bs
            bs = tree[bs]
            bd += 1
        end
    end

    return ad + bd
end

def quickMod(a, b = 10**9 + 7, res = 0)
    # TODO - make this faster
    return a % b
end

n, q = 0, 0
k = 0
tree = []
results = []

# maintain a cache of distances
distCache = []

File.readlines(ARGV[0]).each_with_index do |line, index|
    vals = line.split(' ').map(&:to_i)
    if index == 0
        n, q = vals
    elsif index < n
        a, b = vals.sort
        
        tree[b] = a
        distCache[b] = 0
    else
        if k == 0
            k = vals[0]
        else
            # TODO: This can just be printed out here
            results.push computeQuery k, vals, tree, distCache
           
            # reset k
            k = 0
        end
    end
end

#pp tree
p results

