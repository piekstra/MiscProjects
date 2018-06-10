require_relative 'SentenceWithJoyScore'
require_relative 'SentenceGroupWithJoyScore'

class HappyWordSearch
    def self.ReadArticle(file='sample_article_text.txt')
        return File.read(file)
    end

    def self.ReadSearchWords(params={})
        paramDefaults = {file: 'sample_joy_words.txt', sort: false}
        params = paramDefaults.merge(params)

        words = File.read(params[:file]).downcase.split(', ')

        if params[:sort]
            return words.sort
        else
            return words
        end
    end

    def self.TimedSearch(article, joyWords, findMethod)
        startTime = Time.now
 
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
                found = findMethod.call joyWords, word
                sentenceWithJoyScore.addJoyWord word if found
            end
            
            topSentence = sentenceWithJoyScore.dup if sentenceWithJoyScore.JoyScore > topSentence.JoyScore
            
            currentSentenceGroup.addSentence(sentenceWithJoyScore)   
            topSentenceGroup = currentSentenceGroup.dup if currentSentenceGroup.JoyScore > topSentenceGroup.JoyScore
            
            textTotalScore += sentenceWithJoyScore.JoyScore
        end

        endTime = Time.now
        runtime = endTime - startTime

        puts "Total article score: #{textTotalScore}"
        puts "Highest single-sentence score: #{topSentence.JoyScore}"
        puts "Highest sentence group score: #{topSentenceGroup.JoyScore}"
        puts "Elapsed time: #{runtime}"
    end
end

