def Traverse(node, words = [], word = "")
    if !node
        return
    end

    node.each do |key, value|
        if key == 'value'
            words.push([word, value])
        else
            Traverse value, words, word + key
        end
    end

    return words
end

def PrefixTreeApproach(inputFile, topN)
    root = {}
    node = root

    File.open(inputFile, 'r:utf-8') do |file|
        file.each_char do |char|
            char = char.downcase
            if char >= 'a' && char <= 'z'
                if !node[char]
                    node[char] = {}
                end

                node = node[char]
            else
                if node != root
                    if !node['value']
                        node['value'] = 1
                    else
                        node['value'] += 1
                    end

                    node = root
                end
            end
        end
    end

    topWords = []
    words = Traverse root
    words.each do |word, frequency|
        topWords.insert topWords.index {|pair| pair[1] > frequency} || -1, [word, frequency]
        if topWords.length > topN
            topWords = topWords.drop(1)
        end
    end

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
