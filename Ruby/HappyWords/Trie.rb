class Node
    def initialize()
        @children = {}
        @isWord = false
    end

    def children
        return @children
    end
    
    def isWord
        return @isWord
    end

    def isWord=(value)
        @isWord = value
    end
end

class Trie
    def initialize()
        @root = Node.new
    end

    def Find(key)
        node = @root
        key.split("").each do |char|
            if node.children.key?(char)
                node = node.children[char]        
            else
                # we have a character that the node has no
                # children for, so word is not in the trie
                return false
            end
        end

        return node.isWord
    end

    def Insert(string)
        node = @root
        indexLastChar = -1
        string.split("").each_with_index do |char, index|
            if node.children.key?(char)
                node = node.children[char]
            else
                indexLastChar = index
                break
            end
        end

        # append new nodes for the remaining characters, if any
        if indexLastChar > -1
            string[indexLastChar..-1].split("").each do |char|
                node.children[char] = Node.new
                node = node.children[char]
            end
        end

        node.isWord = true
    end
end

