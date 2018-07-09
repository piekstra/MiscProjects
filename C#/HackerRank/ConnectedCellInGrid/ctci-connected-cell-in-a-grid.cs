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
    
    static IEnumerable<int[]> GetAdjacent(int[][] grid, int row, int col) {
        var adjacentLocations = new List<int[]>();
        var atTop = row+1 == grid.Length;
        var atBottom = row == 0;
        var atLeft = col == 0;
        var atRight = col+1 == grid[row].Length;
        
        if (!atTop) {
            // Up
            adjacentLocations.Add(new []{row+1, col});     
            // Up Left
            if (!atLeft) {
                adjacentLocations.Add(new []{row+1, col-1});
            }      
            // Up Right
            if (!atRight) {
                adjacentLocations.Add(new []{row+1, col+1});
            }  
        }
        
        if (!atBottom) {
            // Down
            adjacentLocations.Add(new []{row-1, col});
            // Down Left
            if (!atLeft) {
                adjacentLocations.Add(new []{row-1, col-1});
            }      
            // Down Right
            if (!atRight) {
                adjacentLocations.Add(new []{row-1, col+1});
            }  
        }
        
        // Left
        if (!atLeft) {
            adjacentLocations.Add(new []{row, col-1});
        }      
        // Right
        if (!atRight) {
            adjacentLocations.Add(new []{row, col+1});
        } 
        
        return adjacentLocations;
    }
    
    static string GetHashKeyFromCoord(int[] coordinate) {
        return GetHashKeyFromRowCol(coordinate[0], coordinate[1]);
    }
    
    static string GetHashKeyFromRowCol(int row, int col) {
        return $"{row}{col}";
    }
    
    static int regionDfs(int[][] grid, int row, int col, HashSet<string> visited) {        
        var regionSize = 0;
        var searchStack = new Stack<int[]>();
        searchStack.Push(new [] {row, col});
        while (searchStack.Count > 0) {
            var coord = searchStack.Pop();
            regionSize++;
            var adjacentCoords = GetAdjacent(grid, coord[0], coord[1]);
            foreach (var adjacentCoord in adjacentCoords) {
                var adjCoordStr = GetHashKeyFromCoord(adjacentCoord);       
                var gridVal = grid[adjacentCoord[0]][adjacentCoord[1]];
                if (!visited.Contains(adjCoordStr) && gridVal == 1) {
                    visited.Add(adjCoordStr);  
                    searchStack.Push(adjacentCoord);
                }
            }
        }
        
        return regionSize;
    }
    
    // Complete the maxRegion function below.
    static int maxRegion(int[][] grid) {
        var visited = new HashSet<string>();
        var largestRegion = 0;
        
        for (var row = 0; row < grid.Length; row++) {
            for (var col = 0; col < grid[row].Length; col++) {
                var coordStr = GetHashKeyFromRowCol(row, col);
                // If this location has already been visited, skip over it
                if (visited.Contains(coordStr)) {
                    continue;
                }                     
                visited.Add(coordStr);          
                  
                // Encountered an unexplored region
                if (grid[row][col] == 1) {
                    // Do a DFS for the region                    
                    var regionSize = regionDfs(grid, row, col, visited);
                    if (regionSize > largestRegion) {
                        largestRegion = regionSize;
                    }
                }
            }
        }
        
        return largestRegion;
    }

    static void Main(string[] args) {
        TextWriter textWriter = new StreamWriter(@System.Environment.GetEnvironmentVariable("OUTPUT_PATH"), true);

        int n = Convert.ToInt32(Console.ReadLine());

        int m = Convert.ToInt32(Console.ReadLine());

        int[][] grid = new int[n][];

        for (int i = 0; i < n; i++) {
            grid[i] = Array.ConvertAll(Console.ReadLine().Split(' '), gridTemp => Convert.ToInt32(gridTemp));
        }

        int res = maxRegion(grid);

        textWriter.WriteLine(res);

        textWriter.Flush();
        textWriter.Close();
    }
}
