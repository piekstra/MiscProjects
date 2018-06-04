require 'set'

# def getSurroundingText(text, wordStartIndex, wordRadius)    
    # textWords = text.split(/\ /)
    
    # wordIndex = 0
    # currentTextLength = 0
    # textWords.each do |word|
        # currentTextLength += word.length + 1        
        # break if currentTextLength > wordStartIndex
        # wordIndex += 1
    # end 
    
    # # Now we have the index of our word, get words on either side of it with
    # firstWordIndex = wordIndex - wordRadius
    # firstWordIndex = 0 if firstWordIndex < 0
    
    # lastWordIndex = wordIndex + wordRadius
    # lastWordIndex = textWords.length if lastWordIndex > textWords.length
    
    # return textWords[firstWordIndex..lastWordIndex].join(' ')
# end


# def getTextNearJoyWords(text, joyWords)
    # results = {}
    # joyWords.each do |word|
        # indexes = text.downcase.enum_for(:scan, /(?=#{word.downcase})/).map { Regexp.last_match.offset(0).first }
        # next unless indexes.any?
        # results[word.downcase] = indexes
    # end
    
    # textNearJoyWords = {}
    # results.keys.each do |resultKey|        
        # results[resultKey].each do |wordStartIndex|
            # surroundingText = getSurroundingText(text, wordStartIndex, 5)
            # textNearJoyWords[resultKey] = {} unless textNearJoyWords.key?(resultKey)
            # textNearJoyWords[resultKey][wordStartIndex] = surroundingText
        # end
    # end
    
    # return textNearJoyWords
# end


# def main()
    # joyWordFile = ARGV[0]
    # textToSearch = ARGV[1]
    
    # joyWords = File.read(joyWordFile).downcase.split(', ')
    # text = File.read(textToSearch)    
    
    # results = getTextNearJoyWords(text, joyWords)
    # results.keys.each do |resultKey|        
        # results[resultKey].keys.each do |index|
            # puts results[resultKey][index]
        # end
    # end
# end


# def getEncapsulatingSentence(text, wordStartIndex)    
    # textSentences = text.scan(/[^\.!?]+[\.!?]/)
    
    # sentenceIndex = 0
    # currentTextLength = 0
    # textSentences.each do |sentence|
        # currentTextLength += sentence.length + 1        
        # break if currentTextLength > wordStartIndex
        # sentenceIndex += 1
    # end 
        
    # return textSentences[sentenceIndex]
# end


# def getTextNearJoyWords(text, joyWords)
    # joyWordIndexes = {}
    # joyWords.each do |word|
        # indexes = text.downcase.enum_for(:scan, /(?=#{word.downcase})/).map { Regexp.last_match.offset(0).first }
        # next unless indexes.any?
        # joyWordIndexes[word.downcase] = indexes
    # end
    
    # # TODO - linked list of sentences, group them by cummulative score, i.e. these 3 sentences each have a joy score, and the three together have a cummulative score of 12 so it's better than a group of 3 sentences with a cumulative score of 10
    
    # joyfulSentences = {}
    # joyWordIndexes.keys.each do |joyWord|        
        # joyWordIndexes[joyWord].each do |wordStartIndex|
            # encapsulatingSentence = getEncapsulatingSentence(text, wordStartIndex)
            # if joyfulSentences.key?(encapsulatingSentence)
                # joyfulSentences[encapsulatingSentence]["score"] += 1
                # joyfulSentences[encapsulatingSentence]["joy_words"].push(joyWord)
            # else
                # joyfulSentences[encapsulatingSentence] = {}
                # joyfulSentences[encapsulatingSentence]["score"] = 1
                # joyfulSentences[encapsulatingSentence]["joy_words"] = [joyWord]
            # end
        # end
    # end
    
    # return joyfulSentences
# end


# def main()
    # joyWordFile = ARGV[0]
    # textToSearch = ARGV[1]
    
    # joyWords = File.read(joyWordFile).downcase.split(', ')
    # text = File.read(textToSearch)    
    
    # sentences = getTextNearJoyWords(text, joyWords)
    # This sort isn't working currently - needs to sort by "score"
    # sentences.sort_by {|_key, value| }.each do |sentence|     
        # puts sentence
        # puts "Score: #{sentences[sentence]["score"]}"
        # puts "Words: #{sentences[sentence]["joy_words"]}"
    # end
# end


def getEncapsulatingSentence(text, wordStartIndex)    
    textSentences = text.scan(/[^\.!?]+[\.!?]/)
    
    sentenceIndex = 0
    currentTextLength = 0
    textSentences.each do |sentence|
        currentTextLength += sentence.length + 1        
        break if currentTextLength > wordStartIndex
        sentenceIndex += 1
    end 
        
    return textSentences[sentenceIndex]
end


def getTextNearJoyWords(text, joyWords)
    joyWordIndexes = {}
    joyWords.each do |word|
        indexes = text.downcase.enum_for(:scan, /(?= #{word.downcase})/).map { Regexp.last_match.offset(0).first }
        next unless indexes.any?
        joyWordIndexes[word.downcase] = indexes
    end
    
    # TODO - linked list of sentences, group them by cummulative score, i.e. these 3 sentences each have a joy score, and the three together have a cummulative score of 12 so it's better than a group of 3 sentences with a cumulative score of 10
    
    joyfulSentences = {}
    joyWordIndexes.keys.each do |joyWord|        
        joyWordIndexes[joyWord].each do |wordStartIndex|
            encapsulatingSentence = getEncapsulatingSentence(text, wordStartIndex)
            if joyfulSentences.key?(encapsulatingSentence)
                joyfulSentences[encapsulatingSentence]["score"] += 1
                joyfulSentences[encapsulatingSentence]["joy_words"].push(joyWord)
            else
                joyfulSentences[encapsulatingSentence] = {}
                joyfulSentences[encapsulatingSentence]["score"] = 1
                joyfulSentences[encapsulatingSentence]["joy_words"] = [joyWord]
            end
        end
    end
    
    return joyfulSentences
end


def main()
    joyWordFile = ARGV[0]
    textToSearch = ARGV[1]
    
    joyWords = File.read(joyWordFile).downcase.split(', ')
    text = File.read(textToSearch)    
    
    sentences = getTextNearJoyWords(text, joyWords)
    sentences.sort_by {|_key, value| }.each do |sentence|     
        puts sentence
        puts "Score: #{sentences[sentence]["score"]}"
        puts "Words: #{sentences[sentence]["joy_words"]}"
    end
end

main()