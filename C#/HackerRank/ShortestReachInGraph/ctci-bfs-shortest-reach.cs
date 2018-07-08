using System;
using System.Linq;
using System.Collections.Generic;
using System.IO;

class Graph {
    private readonly int numNodes;
    public readonly Dictionary<int, List<int>> graph = new Dictionary<int, List<int>>();
    
    public Graph(int numNodes) {
        this.numNodes = numNodes;
        for (var nodeNum = 1; nodeNum <= numNodes; nodeNum++) {
            graph.Add(nodeNum, new List<int>());
        }
    }
    
    public void AddEdge(int nodeOne, int nodeTwo) {
        graph[nodeOne].Add(nodeTwo);
        graph[nodeTwo].Add(nodeOne);
    }
    
    public IEnumerable<long> GetDistances(int startNode) {
        var depths = new long[numNodes+1];        
        var nodeQueue = new Queue<int>();
        nodeQueue.Enqueue(startNode);
        
        while (nodeQueue.Count > 0) {
            var node = nodeQueue.Dequeue();            
            var children = graph[node];            
            foreach (var child in children) {
                // Make sure not to revisit any nodes
                if (depths[child] == 0) {
                    // Depth is the depth of the parent + 1
                    depths[child] = depths[node] + 1;
                    nodeQueue.Enqueue(child);
                }
            }         
        }
        
        var distances = new long[numNodes-1];
        var distanceIdx = 0;
        for(var nodeIdx = 1; nodeIdx < numNodes+1; nodeIdx++) {
            if (nodeIdx == startNode) continue;
            distances[distanceIdx++] = depths[nodeIdx] == 0 ? -1 : depths[nodeIdx]*6;            
        }
        
        return distances;
    }
}

class Solution {
    static void Main(String[] args) {
        /* Enter your code here. Read input from STDIN. Print output to STDOUT. Your class should be named Solution */
        var numQueries = int.Parse(Console.ReadLine());        
        for (var query = 0; query < numQueries; query++) {
            var nm = Console.ReadLine().Split(' ');
            var numNodes = int.Parse(nm[0]);
            var numEdges = int.Parse(nm[1]);
            
            var graph = new Graph(numNodes);
            for (var edgeNum = 0; edgeNum < numEdges; edgeNum++) {
                var edge = Console.ReadLine().Split(' ');
                var nodeOne = int.Parse(edge[0]);
                var nodeTwo = int.Parse(edge[1]);
                graph.AddEdge(nodeOne, nodeTwo);
            }
            
            var startNode = int.Parse(Console.ReadLine());
            var distances = graph.GetDistances(startNode);
            Console.WriteLine(string.Join(" ", distances.Select(x => x.ToString()).ToArray()));
        }
    }
}