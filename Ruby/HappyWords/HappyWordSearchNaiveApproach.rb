require_relative 'HappyWordSearch'

def Find(joyWords, word)
    return joyWords.include? word
end

article = HappyWordSearch.ReadArticle
words = HappyWordSearch.ReadSearchWords

HappyWordSearch.TimedSearch article, words, method(:Find)

