using System;
using System.Collections.Generic;
using System.IO;

class StackNode {
    public readonly int data;
    public StackNode next;
    
    public StackNode(int data) {
        this.data = data;
    }
}

class Stack {
    private StackNode top = null;
    
    public bool IsEmpty() {
        return top == null;    
    }
    
    public int Peek() {
        if (top == null) {
            throw new InvalidOperationException("The stack is empty");
        }
        
        return top.data;
    }
    
    public int Pop() {
        if (top == null) {
            throw new InvalidOperationException("The stack is empty");
        }
        
        var data = top.data;
        top = top.next;
        return data;
    }
    
    public void Push(int data) {
        var node = new StackNode(data);
        node.next = top;
        top = node;
    }
}

class Queue {    
    private readonly Stack pushStack = new Stack();
    private readonly Stack popStack = new Stack();
    
    private void PopulatePopStackIfNeeded() {
        if (popStack.IsEmpty()) {
            while (!pushStack.IsEmpty()) {
                popStack.Push(pushStack.Pop());
            }
        }        
    }  
    
    public int Peek() {
        PopulatePopStackIfNeeded();
        return popStack.Peek();
    }
    
    public int Pop() {
        PopulatePopStackIfNeeded();
        return popStack.Pop();
    }
    
    public void Push(int data){ 
        pushStack.Push(data);
    }
}

class Solution {
    static void Main(String[] args) {
        /* Enter your code here. Read input from STDIN. Print output to STDOUT. Your class should be named Solution */
        var queue = new Queue();
        var numQueries = int.Parse(Console.ReadLine());
        for (var i = 0; i < numQueries; i++) {
            var input = Console.ReadLine().Split(' ');
            var command = int.Parse(input[0]);
            switch (command) {
                case 1:
                    var data = int.Parse(input[1]);
                    queue.Push(data);
                    break;
                case 2:
                    queue.Pop();
                    break;
                case 3:
                    Console.WriteLine(queue.Peek());
                    break;
            }
        }
    }
}