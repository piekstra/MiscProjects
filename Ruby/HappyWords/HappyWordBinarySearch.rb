require_relative 'HappyWordSearch'
require_relative 'BinarySearch'

def Find(joyWords, word)
    return BinarySearch.InArray joyWords, word
end

article = HappyWordSearch.ReadArticle
words = HappyWordSearch.ReadSearchWords sort: true

HappyWordSearch.TimedSearch article, words, method(:Find)

