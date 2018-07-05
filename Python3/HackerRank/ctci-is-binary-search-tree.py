""" Node is defined as
class node:
    def __init__(self, data):
        self.data = data
        self.left = None
        self.right = None
"""

def checkBST(root):
    stack = []
    current = root    
    greatestNum = 0
    while stack or current:
        while current:
            stack.append(current)
            current = current.left
        visit = stack.pop()
        if visit.data > greatestNum:
            greatestNum = visit.data
        else:
            return False
        current = visit.right
    return True