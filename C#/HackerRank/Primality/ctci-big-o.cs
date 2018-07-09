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
    // Complete the primality function below.
    static bool primality(int n) {
        if (n < 2)
            return false;
        if (n == 2) 
            return true;
        if (n % 2 == 0)
            return false;
        
        // Only check up to and including the square root of n
        var maxMultiple = Math.Floor(Math.Sqrt(n));
        var multiple = 3;
        while (multiple <= maxMultiple) {
            if (n % multiple == 0)
                return false;
            // Skip even numbers
            multiple += 2;
        }
        
        return true;
    }

    static void Main(string[] args) {
        TextWriter textWriter = new StreamWriter(@System.Environment.GetEnvironmentVariable("OUTPUT_PATH"), true);

        int p = Convert.ToInt32(Console.ReadLine());

        for (int pItr = 0; pItr < p; pItr++) {
            int n = Convert.ToInt32(Console.ReadLine());

            bool isPrime = primality(n);

            textWriter.WriteLine(isPrime ? "Prime" : "Not prime");
        }

        textWriter.Flush();
        textWriter.Close();
    }
}

