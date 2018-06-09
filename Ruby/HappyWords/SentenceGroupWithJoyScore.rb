class SentenceGroupWithJoyScore
    def initialize(groupSize = 3)
        @groupSize = groupSize
        @sentences = []
        @joyScore = 0
    end
    
    def addSentence(sentenceWithJoyScore)
        if @sentences.length == @groupSize
            @joyScore -= @sentences[0].JoyScore
            @sentences = @sentences.drop(1)          
        end
        @sentences.push(sentenceWithJoyScore)
        @joyScore += sentenceWithJoyScore.JoyScore
    end
    
    def JoyScore
        @joyScore
    end
    
    def Sentences
        @sentences
    end
end

