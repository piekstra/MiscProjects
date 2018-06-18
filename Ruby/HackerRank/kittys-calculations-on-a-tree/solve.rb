require 'pp'

def computeQuery(k, vals, tree, distCache)
    result = 0
    (vals.combination 2).each do |c|
        a, b = c
        d = dist a, b, tree, distCache
        expression = quickMod(a) * quickMod(b) * quickMod(d)
        result += quickMod expression
    end

    return quickMod result
end

def dist(origin, target, tree, distCache)
    cacheMisses = 0
    cacheHit = nil
    
    distance = 0
    prevNode = nil
    q = []

    cacheHit = distCache[[origin, target]]
    if cacheHit
        distance += cacheHit
    else
        q.push origin
    end
    
    while !q.empty?
        currentNode = q.shift
        
        if !currentNode
            distance += 1 
            prevNode = q.shift
            next
        end
        
        # see if we already have the distance cached
        cacheHit = distCache[[currentNode, target]]
        if cacheHit
            distance += cacheHit
            break
        else
            cacheMisses += 1
            distCache[[origin, currentNode]] = distance
        end

        break if currentNode == target

        keys = tree[currentNode].keys
        if keys.any?
            q.push nil, currentNode
            keys.map {|key| q.push key if key != prevNode}
        end
    end
    
    puts "Cache hit? #{cacheHit != nil}; Cache misses: #{cacheMisses}"
    return distance
end

def quickMod(a, b = 10**9 + 7, res = 0)
    # TODO - make this faster
    return a % b
end

n, q = 0, 0
k = 0
tree = {}
results = []

# maintain a cache of distances
distCache = {}

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
            results.push computeQuery k, vals, tree, distCache
           
            # reset k
            k = 0
        end
    end
end

#pp tree
p results

