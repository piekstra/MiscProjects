def NaiveApproach(inputFile, topN)
    topNWords = {} 

    File.open(inputFile, 'r:utf-8') do |file|

        currentWord = ""
        lastCharWasLetter = false

        file.each_char do |char|
            char = char.downcase
            if char >= 'a' && char <= 'z'
                currentWord += char
                lastCharWasLetter = true
            else
                if lastCharWasLetter
                    if topNWords.key? currentWord
                        topNWords[currentWord] += 1
                    else
                        topNWords[currentWord] = 1
                    end
                end

                currentWord = ""
                lastCharWasLetter = false
            end
        end
    end

    topWords = []
    topNWords.each do |word, frequency|
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
result = NaiveApproach inputFile, topN.to_i
endTime = Time.now
runtime = endTime - startTime

puts "Top #{topN}:\n\t#{result}"
puts "Time elapsed: #{runtime}"
