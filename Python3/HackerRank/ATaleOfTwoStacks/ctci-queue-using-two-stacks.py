class StackNode(object):
    
    def __init__(self, value):
        self.value = value
        self.next = None
    
class Stack(object):       
    
    def __init__(self):
        self.top = None
        
    def isEmpty(self):
        return self.top is None
    
    def peek(self):
        return self.top.value
        
    def pop(self):
        data = self.top.value
        self.top = self.top.next
        return data
            
    def push(self, value):  
        node = StackNode(value)
        node.next = self.top
        self.top = node

class MyQueue(object):       
    
    def __init__(self):
        self.pushStack = Stack()
        self.popStack = Stack()               
    
    def populatePopStackIfNeeded(self):
        if self.popStack.isEmpty():
            while not self.pushStack.isEmpty():
                self.popStack.push(self.pushStack.pop())
    
    def peek(self):
        self.populatePopStackIfNeeded()
        return self.popStack.peek()
        
    def pop(self):
        self.populatePopStackIfNeeded()
        return self.popStack.pop()
            
    def put(self, value):       
        self.pushStack.push(value)
        

queue = MyQueue()
t = int(input())
for line in range(t):
    values = map(int, input().split())
    values = list(values)
    if values[0] == 1:
        queue.put(values[1])        
    elif values[0] == 2:
        queue.pop()
    else:
        print(queue.peek())