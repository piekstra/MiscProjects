using System;
using System.Collections.Generic;
using System.IO;

class Solution {
    private static Dictionary<int, int> knownFibs = new Dictionary<int, int> {{0,0},{1,1}};
    
    public static int Fibonacci(int n) {
        if (knownFibs.ContainsKey(n)) {
            return knownFibs[n];
        }        
        knownFibs[n] = Fibonacci(n-1) + Fibonacci(n-2);
        return knownFibs[n];
    }

    static void Main(String[] args) {
        int n = Convert.ToInt32(Console.ReadLine());
        Console.WriteLine(Fibonacci(n));
    }
}
