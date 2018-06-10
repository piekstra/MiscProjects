require_relative 'JoyWordWithOcurrences'
require_relative 'SentenceWithJoyScore'
require_relative 'SentenceGroupWithJoyScore'
require_relative 'BinarySearch'

startTime = Time.now

joyWordFile = 'sample_joy_words.txt'
textToSearch = 'sample_article_text.txt'

joyWords = File.read(joyWordFile).downcase.split(', ').sort
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
    wordsToSearch = sentence.split(' ').map(&:downcase)
    wordsToSearch.each do |word|
        matchCount = BinarySearch.CountOccurrences joyWords, word
        sentenceWithJoyScore.addJoyWordWithOcurrence(word, matchCount) if matchCount > 0
    end
    
    topSentence = sentenceWithJoyScore.dup if sentenceWithJoyScore.JoyScore > topSentence.JoyScore
    
    currentSentenceGroup.addSentence(sentenceWithJoyScore)   
    topSentenceGroup = currentSentenceGroup.dup if currentSentenceGroup.JoyScore > topSentenceGroup.JoyScore
    
    textTotalScore += sentenceWithJoyScore.JoyScore
end

endTime = Time.now

puts "Total score: #{textTotalScore}"
puts "Highest scoring (#{topSentence.JoyScore}) sentence: #{topSentence.Sentence}"
puts "Highest scoring (#{topSentenceGroup.JoyScore}) group of sentences: #{topSentenceGroup.Sentences}"
puts "Time elapsed: #{endTime - startTime}"
