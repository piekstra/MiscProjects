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

class Solution 
{
    private static void EnqueueAll(Queue<int> stack, IEnumerable<int> values) {
        foreach (var val in values) {
            stack.Enqueue(val);
        }
    }
    
    // Complete the roadsAndLibraries function below.    
    // n - number of cities
    // c_lib - cost of building a library
    // c_road - coast of building a road
    // cities - city graph as an array
    static long roadsAndLibraries(long n, long c_lib, long c_road, int[][] cities)
    {
        // If the cost of building a road is greater than or equal to 
        // the cost of building a library, it will never make sense to 
        // build a road to connect a city instead of just building a 
        // library in that city. This is because any chain of cities 
        // will always need at least one library, so assuming we start 
        // with one city with a library... building a road will only 
        // connect one more city. So, simply build a library in every city
        if (c_road >= c_lib)
        {
            return c_lib * n;
        }
        
        // Create a node->children structure so we can do a BFS of the graphs
        var cityMap = new Dictionary<int, HashSet<int>>();
        foreach (var cityRoad in cities) {
            if (cityMap.ContainsKey(cityRoad[0])) {
                cityMap[cityRoad[0]].Add(cityRoad[1]);
            } else {
                cityMap.Add(cityRoad[0], new HashSet<int> {cityRoad[1]});
            }
            
            if (cityMap.ContainsKey(cityRoad[1])) {
                cityMap[cityRoad[1]].Add(cityRoad[0]);
            } else {
                cityMap.Add(cityRoad[1], new HashSet<int> {cityRoad[0]});
            }
        }
                
        long libraries = n;
        long roads = 0;
        
        var visited = new HashSet<int>();
        
        foreach (var city in cityMap.Keys) {
            if (visited.Contains(city)){
                continue;
            }
            
            visited.Add(city);
            
            var searchQueue = new Queue<int>();
            EnqueueAll(searchQueue, cityMap[city]);
            
            while (searchQueue.Any()) {
                var searchCity = searchQueue.Dequeue();           
                if (!visited.Contains(searchCity)) {
                    visited.Add(searchCity);
                    EnqueueAll(searchQueue, cityMap[searchCity]);
                    roads++;
                    libraries--;
                }
            }
        }

        // The total cost is the number of roads times the cost for a road,
        // plus the number of libraries times the cost for a library
        return roads * c_road + libraries * c_lib;
    }

    static void Main(string[] args) {
        TextWriter textWriter = new StreamWriter(@System.Environment.GetEnvironmentVariable("OUTPUT_PATH"), true);

        int q = Convert.ToInt32(Console.ReadLine());

        for (int qItr = 0; qItr < q; qItr++) {
            string[] nmC_libC_road = Console.ReadLine().Split(' ');

            int n = Convert.ToInt32(nmC_libC_road[0]);

            int m = Convert.ToInt32(nmC_libC_road[1]);

            int c_lib = Convert.ToInt32(nmC_libC_road[2]);

            int c_road = Convert.ToInt32(nmC_libC_road[3]);

            int[][] cities = new int[m][];

            for (int i = 0; i < m; i++) {
                cities[i] = Array.ConvertAll(Console.ReadLine().Split(' '), citiesTemp => Convert.ToInt32(citiesTemp));
            }

            long result = roadsAndLibraries(n, c_lib, c_road, cities);

            textWriter.WriteLine(result);
        }

        textWriter.Flush();
        textWriter.Close();
    }
}
