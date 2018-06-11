class Node
    def initialize(value)
        @value = value
        @right = nil
        @left = nil
    end

    def value
        return @value
    end

    def value=(val)
        @value = val
    end

    def right
        return @right
    end

    def right=(node)
        @right = node
    end

    def left
        return @left
    end

    def left=(node)
        @left = node
    end
end

class Tree
    def initialize(node)
        @root = node
    end

    def Inorder(node = @root, nodes = [])
        return if !node

        Inorder node.left, nodes
        nodes.push node.value
        Inorder node.right, nodes
        return nodes
    end

    def Preorder(node = @root, nodes = [])
        return if !node

        nodes.push node.value
        Preorder node.left, nodes
        Preorder node.right, nodes
        return nodes
    end

    def Postorder(node = @root, nodes = [])
        return if !node

        Postorder node.left, nodes
        Postorder node.right, nodes
        nodes.push node.value
        return nodes
    end

    def Insert(value, node = @root)
        if node.value < value
            if node.right
                Insert value, node.right
            else
                node.right = Node.new value
            end
        else
            if node.left
                Insert value, node.left
            else
                node.left = Node.new value
            end
        end
    end
end

tree = Tree.new Node.new 3
tree.Insert 10
tree.Insert 19
tree.Insert 66
tree.Insert 2
tree.Insert 1
tree.Insert 199
tree.Insert 82
tree.Insert 42

puts "Inorder #{tree.Inorder}"
puts "Preorder #{tree.Preorder}"
puts "Postorder #{tree.Postorder}"

