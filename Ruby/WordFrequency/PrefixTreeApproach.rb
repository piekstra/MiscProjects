def Traverse(node, words = [], word = "")
    node.each do |key, value|
        if key == 'val'
            words.push([word, value])
        else
            Traverse value, words, word + key
        end
    end

    return words
end

def TraverseIterativeWithTopN(root, topN)
    topWords = []
    nodeStack = [[root, ""]]
    while nodeStack.any?
        node,word = nodeStack.pop
        node.each do |key, value|
            if key == 'val'
                topWords.insert topWords.index {|pair| pair[1] < value} || -1, [word, value]
                topWords.pop if topWords.length > topN
            else
                nodeStack.push [value, word+key]
            end
        end
    end

    return topWords
end

def PrefixTreeApproach(inputFile, topN)
    root = {}
    node = root

    File.open(inputFile, 'r:utf-8') do |file|
        file.each_char do |char|
            char = char.downcase
            if char >= 'a' && char <= 'z'
                node[char] = {} if !node[char]
                node = node[char]
            elsif node != root
                node['val'] = (node['val'] || 0) + 1
                node = root
            end
        end
    end

    #topWords = []
    #words = Traverse root
    #words.each do |word, frequency|
    #    topWords.insert topWords.index {|pair| pair[1] > frequency} || -1, [word, frequency]
    #    if topWords.length > topN
    #        topWords = topWords.drop(1)
    #    end
    #end

    topWords = TraverseIterativeWithTopN root, topN
    
    return topWords
end

if ARGV.length < 2
    puts "Expected the following format:"
    puts "ruby #{$0} inputFile.txt 10"
    exit
end

inputFile, topN = ARGV

startTime = Time.now
result = PrefixTreeApproach inputFile, topN.to_i
endTime = Time.now
runtime = endTime - startTime

puts "Top #{topN}:\n\t#{result}"
puts "Time elapsed: #{runtime}"
