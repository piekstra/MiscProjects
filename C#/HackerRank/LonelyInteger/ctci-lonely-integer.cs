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

    // Complete the findLonely function below.
    static int findLonely(List<int> arr) {
        var lonelyNum = arr[0];
        for (var numIdx = 1; numIdx < arr.Count; numIdx++) {
            lonelyNum ^= arr[numIdx];
        }
        
        return lonelyNum;
    }

    static void Main(string[] args) {
        TextWriter textWriter = new StreamWriter(@System.Environment.GetEnvironmentVariable("OUTPUT_PATH"), true);

        int n = Convert.ToInt32(Console.ReadLine().Trim());

        List<int> arr = Console.ReadLine().TrimEnd().Split(' ').ToList().Select(arrTemp => Convert.ToInt32(arrTemp)).ToList();

        int res = findLonely(arr);

        textWriter.WriteLine(res);

        textWriter.Flush();
        textWriter.Close();
    }
}

