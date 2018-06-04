class JoyWordWithOcurrences
    def initialize(word, ocurrences)
        @word = word
        @ocurrences = ocurrences
    end
end

class SentenceWithJoyScore    
    def initialize(sentence)
        @sentence = sentence
        @joyWordsWithOcurrences = []
        @joyScore = 0
    end
    
    def addJoyWordWithOcurrence(word, ocurrences)
        @joyWordsWithOcurrences.push(JoyWordWithOcurrences.new(word, ocurrences))
        @joyScore += ocurrences
    end
    
    def joyScore
        @joyScore
    end
end

class SentenceGroupWithJoyScore
    
    def initialize(groupSize=3)
        @groupSize = groupSize
        @sentences = []
        @joyScore = 0
    end
    
    def addSentence(sentenceWithJoyScore)
        if @sentences.length == @groupSize
            @joyScore -= @sentences[0].joyScore
            @sentences = @sentences.drop(1)          
        end
        @sentences.push(sentenceWithJoyScore)
        @joyScore += sentenceWithJoyScore.joyScore
    end
    
    def joyScore
        @joyScore
    end
end


joyWordFile = 'sample_joy_words.txt'
textToSearch = 'sample_article_text.txt'

joyWords = File.read(joyWordFile).downcase.split(', ')
text = File.read(textToSearch)    
textSentences = text.scan(/[^\.!?]+[\.!?]/)

topSentence = SentenceWithJoyScore.new(nil)
currentSentenceGroup = SentenceGroupWithJoyScore.new
topSentenceGroup = SentenceGroupWithJoyScore.new
# Total score for the entire text
textTotalScore = 0

textSentences.each do |sentence|
    # Look for the Joy Words in the sentence
    # The count of joy words is the score
    sentenceWithJoyScore = SentenceWithJoyScore.new(sentence)
    joyWords.each do |word|
        matches = sentence.scan(/( #{word.downcase}[^a-zA-Z]|#{word.capitalize}[^a-zA-Z]| #{word.capitalize}[^a-zA-Z])/).size
        sentenceWithJoyScore.addJoyWordWithOcurrence(word, matches) if matches > 0
    end
    
    topSentence = sentenceWithJoyScore if sentenceWithJoyScore.joyScore > topSentence.joyScore
    
    currentSentenceGroup.addSentence(sentenceWithJoyScore)   
    topSentenceGroup = currentSentenceGroup if currentSentenceGroup.joyScore > topSentenceGroup.joyScore
    
    textTotalScore += sentenceWithJoyScore.joyScore
end

puts "Total score: #{textTotalScore}"
puts "Highest scoring sentence: #{topSentence}"
puts "Highest scoring group of sentences: #{topSentenceGroup}"