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

class Solution {
    static void Main(string[] args) {
        int t = Convert.ToInt32(Console.ReadLine());

        for (int tItr = 0; tItr < t; tItr++) {
            string expression = Console.ReadLine();
            var bracketStack = new Stack<char>();
            var balanced = true;     
            foreach (var c in expression) {
                if (c.Equals('{') || c.Equals('(') || c.Equals('[')) {
                    bracketStack.Push(c);
                } else if (bracketStack.Count == 0) {
                    balanced = false;
                    break;
                } else {                    
                    if (c.Equals('}') && !bracketStack.Pop().Equals('{')
                       || c.Equals(')') && !bracketStack.Pop().Equals('(')
                       || c.Equals(']') && !bracketStack.Pop().Equals('[')) {
                        balanced = false; 
                        break;
                    }
                }
            }
            
            // Any leftovers means it's not balanced
            if (bracketStack.Count > 0) {
                balanced = false;
            }

            Console.WriteLine(balanced ? "YES" : "NO");
        }
    }
}
