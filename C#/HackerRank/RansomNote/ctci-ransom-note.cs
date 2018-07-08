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

    // Complete the checkMagazine function below.
    static void checkMagazine(string[] magazine, string[] note) {
        var magazineWords = new Dictionary<string, int>();
        foreach (var word in magazine) {
            if (magazineWords.ContainsKey(word)) {                
                magazineWords[word]++;
            } else {
                magazineWords.Add(word, 1);
            }
        }
        
        var checkPassed = true;
        
        foreach (var word in note) {
            if (!magazineWords.ContainsKey(word)) {
                checkPassed = false;
                break;
            } else if (magazineWords[word] > 0) {
                magazineWords[word]--;
            } else {
                checkPassed = false;
                break;
            }
        }
        
        Console.WriteLine(checkPassed ? "Yes" : "No");
    }

    static void Main(string[] args) {
        string[] mn = Console.ReadLine().Split(' ');

        int m = Convert.ToInt32(mn[0]);

        int n = Convert.ToInt32(mn[1]);

        string[] magazine = Console.ReadLine().Split(' ');

        string[] note = Console.ReadLine().Split(' ');

        checkMagazine(magazine, note);
    }
}
