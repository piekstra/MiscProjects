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

    // Complete the makeAnagram function below.
    static int makeAnagram(string a, string b) {
        var aDict = new Dictionary<char, int>();
        foreach (var c in a) {
            if (!aDict.ContainsKey(c)){
                aDict[c] = 1;
            } else {
                aDict[c]++;
            }
        }
        
        var deletions = 0;
        var bSimilarDict = new Dictionary<char, int>();
        foreach (var c in b) {
            if (!aDict.ContainsKey(c)) {
                deletions += 1;
            } else {
                aDict[c] -= 1;
            }
        }
        
        foreach (var aDictVal in aDict.Values) {
            deletions += Math.Abs(aDictVal);
        }
        
        return deletions;
    }

    static void Main(string[] args) {
        TextWriter textWriter = new StreamWriter(@System.Environment.GetEnvironmentVariable("OUTPUT_PATH"), true);

        string a = Console.ReadLine();

        string b = Console.ReadLine();

        int res = makeAnagram(a, b);

        textWriter.WriteLine(res);

        textWriter.Flush();
        textWriter.Close();
    }
}
