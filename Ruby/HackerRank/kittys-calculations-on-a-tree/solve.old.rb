require 'pp'

# maintain a cache of distances
distCache = {}

def computeQuery(k, vals, tree)
    result = 0
    (vals.combination 2).each do |c|
        a, b = c
        d = dist a, b, tree
        expression = quickMod a * quickMod b * quickMod d
        result += quickMod expression
    end

    return quickMod result
end

def dist(a, b, tree, d = 0)
    return distCache[[a, b]] if distCache[[a,b]]

    
    q = []
    v = {}
    q.push a
    v[a] = true

    while !q.empty?
        s, d = q.shift

        tree[s].keys.each do |n|
            return d+1 if n == b

            if !v[n]
                q.push n
                v[q] = true
            end
        end
    end

    return d
end

def quickMod(a, b = 10**9 + 7, res = 0)
    # TODO - make this faster
    return a % b
end

n, q = 0, 0
k = 0
tree = {}
results = []

File.readlines(ARGV[0]).each_with_index do |line, index|
    vals = line.split(' ').map(&:to_i)
    if index == 0
        n, q = vals
    elsif index < n
        a, b = vals
        
        tree[a] = {} if !tree.key? a
        tree[b] = {} if !tree.key? b
        tree[a][b] = nil
        tree[b][a] = nil
    else
        if k == 0
            k = vals[0]
        else
            # TODO: This can just be printed out here
            results.push computeQuery k, vals, tree
           
            # reset k
            k = 0
        end
    end
end

pp tree
pp results

