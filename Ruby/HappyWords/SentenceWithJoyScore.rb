require_relative 'JoyWordWithOcurrences'

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
    
    def JoyScore
        @joyScore
    end
    
    def Sentence
        @sentence
    end
end

