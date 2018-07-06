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

        // In the case where roads are cheaper than libraries, we want to form
        // the longest acyclic graphs possible and place a library in each one
        long libraries = n;
        long roads = 0;
        // A dictionary mapping a city number to the set of cities connected
        // to that city in an acyclic graph
        var connectedCities = new Dictionary<int, HashSet<int>>();
        foreach (var cityRoad in cities)
        {
            int firstCityNum = cityRoad[0];
            int secondCityNum = cityRoad[1];
            var firstCityInGraph = connectedCities.ContainsKey(firstCityNum);
            var secondCityInGraph = connectedCities.ContainsKey(secondCityNum);
            var addRoad = false;

            // There are four cases in which we add a road:
            // Neither city in graph
            // First city not in a graph, second is
            // Second city in a graph, first is
            // Both cities are in separate graphs
            if (!firstCityInGraph && !secondCityInGraph)
            {
                var graph = new HashSet<int> { firstCityNum, secondCityNum };
                connectedCities.Add(firstCityNum, graph);
                connectedCities.Add(secondCityNum, graph);
                addRoad = true;
            }
            else if (!firstCityInGraph)
            {
                // Connect them with a road
                var secondCityGraph = connectedCities[secondCityNum];
                secondCityGraph.Add(firstCityNum);
                connectedCities.Add(firstCityNum, secondCityGraph);
                addRoad = true;
            }
            // The second city didn't belong to a graph (first did) 
            else if (!secondCityInGraph)
            {
                // Connect them with a road
                var firstCityGraph = connectedCities[firstCityNum];
                firstCityGraph.Add(secondCityNum);
                connectedCities.Add(secondCityNum, firstCityGraph);
                addRoad = true;
            }
            // Both cities were already in graphs
            else
            {
                // If their graphs are the same, do nothing
                // Otherwise, connect the graphs with a road
                // and remove one of their libraries
                var firstCityGraph = connectedCities[firstCityNum];
                var secondCityGraph = connectedCities[secondCityNum];
                // As an optimization, we are doing a reference comparison here
                if (firstCityGraph != secondCityGraph)
                {
                    secondCityGraph.UnionWith(firstCityGraph);
                    // As a tradeoff of comparing by reference, we need to 
                    // Go through each item from the other graph and update the
                    // references to refer to our new, merged graph
                    foreach (var cityNum in firstCityGraph)
                    {
                        connectedCities[cityNum] = secondCityGraph;
                    }

                    addRoad = true;
                }
            }

            if (addRoad)
            {
                roads++;
                libraries--;
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
