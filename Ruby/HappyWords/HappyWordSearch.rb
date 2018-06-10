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

    def self.TimedSearch(article, words, search)
        startTime = Time.now
        result = search.call(article, words)
        endTime = Time.now
        return endTime - startTime, result
    end
end

