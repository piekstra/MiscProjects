require_relative 'HappyWordSearch'
require_relative 'Trie'

def Find(trie, word)
    return trie.Find word
end

article = HappyWordSearch.ReadArticle
words = HappyWordSearch.ReadSearchWords sort: true

joyWordTrie = Trie.new
words.each do |word|
    joyWordTrie.Insert word
end

HappyWordSearch.TimedSearch article, joyWordTrie, method(:Find)

