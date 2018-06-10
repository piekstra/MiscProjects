require_relative 'SentenceWithJoyScore'
require_relative 'SentenceGroupWithJoyScore'
require_relative 'HappyWordSearch'

def Search(article, joyWords)
    textSentences = article.scan(/[^\.!?]+[\.!?]/)

    topSentence = SentenceWithJoyScore.new(nil)
    currentSentenceGroup = SentenceGroupWithJoyScore.new
    topSentenceGroup = SentenceGroupWithJoyScore.new
    textTotalScore = 0

    textSentences.each do |sentence|
        # Look for the Joy Words in the sentence
        # The count of joy words is the score
        sentenceWithJoyScore = SentenceWithJoyScore.new(sentence)
        wordsToSearch = sentence.split(' ').map(&:downcase)
        
        wordsToSearch.each do |word|
            found = joyWords.include? word
            sentenceWithJoyScore.addJoyWord word if found
        end
        
        topSentence = sentenceWithJoyScore.dup if sentenceWithJoyScore.JoyScore > topSentence.JoyScore
        
        currentSentenceGroup.addSentence(sentenceWithJoyScore)   
        topSentenceGroup = currentSentenceGroup.dup if currentSentenceGroup.JoyScore > topSentenceGroup.JoyScore
        
        textTotalScore += sentenceWithJoyScore.JoyScore
    end

    resultMessage = "Total article score: #{textTotalScore}\n"
    resultMessage += "Highest scoring sentence: #{topSentence.JoyScore}\n"
    resultMessage += "Highest scoring sentence group: #{topSentenceGroup.JoyScore}\n"
end

article = HappyWordSearch.ReadArticle()
words = HappyWordSearch.ReadSearchWords()
runtime, results = HappyWordSearch.TimedSearch(article, words, method(:Search))

puts "Results: #{results}"
puts "Elapsed time: #{runtime}"

