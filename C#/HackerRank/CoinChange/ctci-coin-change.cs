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
            
    // Complete the ways function below.
    static long ways(int n, int[] coins) 
    {
        var waysToSplit = new long[n+1];
        waysToSplit[0] = 1; // One way to give change for no money
        
        foreach (var currentCoin in coins) {
            for (var amt = currentCoin; amt <= n; amt++) {
                waysToSplit[amt] += waysToSplit[amt - currentCoin];
            }
        }
        
        return waysToSplit[n];
    }

    static void Main(string[] args) {
        TextWriter textWriter = new StreamWriter(@System.Environment.GetEnvironmentVariable("OUTPUT_PATH"), true);

        string[] nm = Console.ReadLine().Split(' ');

        int n = Convert.ToInt32(nm[0]);

        int m = Convert.ToInt32(nm[1]);

        int[] coins = Array.ConvertAll(Console.ReadLine().Split(' '), coinsTemp => Convert.ToInt32(coinsTemp));
        Array.Sort(coins);
        long res = ways(n, coins);

        textWriter.WriteLine(res);

        textWriter.Flush();
        textWriter.Close();
    }
}
