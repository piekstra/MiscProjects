class SentenceWithJoyScore    
    def initialize(sentence)
        @sentence = sentence
        @joyWordsInSentence = []
        @joyScore = 0
    end
    
    def addJoyWord(word)
        @joyWordsInSentence.push(word)
        @joyScore += 1
    end
    
    def JoyScore
        @joyScore
    end
    
    def Sentence
        @sentence
    end
end

