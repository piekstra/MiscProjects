using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.Collections;
using System.ComponentModel;
using System.Diagnostics.CodeAnalysis;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Runtime.Serialization;
using System.Text.RegularExpressions;
using System.Text;
using System;

class ContactTrieNode {
    public Dictionary<char, ContactTrieNode> Children = new Dictionary<char, ContactTrieNode>();
    public int ChildWords = 0;
}

class ContactTrie {
    private ContactTrieNode root = new ContactTrieNode();
    
    public void Add(string contactName) {
        var node = root;
        foreach (var c in contactName) {
            node.ChildWords++;
            if (!node.Children.ContainsKey(c)) {
                node.Children[c] = new ContactTrieNode();
            }
            
            node = node.Children[c];
        }
        
        node.ChildWords++;
    }
    
    public int Find(string nameSubstring) {
        var node = root;
        foreach (var c in nameSubstring) {
            if (node.Children.ContainsKey(c)) {
                node = node.Children[c];
            } else {
                return 0;
            }
        }
        
        return node.ChildWords;
    }
}

class Solution {
    static void Main(string[] args) {
        var contactTrie = new ContactTrie();
        int n = Convert.ToInt32(Console.ReadLine());
        for (int nItr = 0; nItr < n; nItr++) {
            string[] opContact = Console.ReadLine().Split(' ');

            string op = opContact[0];
            
            string contact = opContact[1];
            
            switch (op) {
                case "add":
                    contactTrie.Add(contact);
                    break;
                case "find":
                    Console.WriteLine(contactTrie.Find(contact));
                    break;
            }
        }
    }
}
