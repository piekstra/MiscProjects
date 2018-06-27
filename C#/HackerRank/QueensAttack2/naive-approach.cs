using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.Collections;
using System.ComponentModel;
using System.Diagnostics.CodeAnalysis;
using System.Globalization;
using System.IO;
using System.Linq;
//using System.Linq.ParallelQuery;
using System.Reflection;
using System.Runtime.Serialization;
using System.Text.RegularExpressions;
using System.Text;
using System;

class Solution {

    // Complete the queensAttack function below.
    static int queensAttack(int n, int k, int r_q, int c_q, int[][] obstacles) {
        var queensMoves = new int[8][] {
            new int[] {1, 1},     // Up right
            new int[] {1, 0},     // Up
            new int[] {1, -1},    // Up left
            new int[] {0, -1},    // Left
            new int[] {-1, -1},   // Down left
            new int[] {-1, 0},    // Down
            new int[] {-1, 1},    // Down right
            new int[] {0, 1},     // right
        };  
        
        var attacks = 0;               
        var startPos = new int[] {r_q, c_q};        
        foreach (var queensMove in queensMoves){
            var currentPos = move(startPos, queensMove);
            while (!outOfBounds(currentPos, n) && !blocked(currentPos, obstacles)) {
                attacks += 1;
                currentPos = move(currentPos, queensMove);
            }
        }        
        
        return attacks;
    }
    
    static bool blocked(int[] position, int[][] obstacles) {        
        return obstacles.Where(obstacle => obstacle.SequenceEqual(position)).Any();
    }
    
    static int[] move(int[] position, int[] direction) {
        return position.Zip(direction, (x, y) => x + y).ToArray();
    }
    
    static bool outOfBounds(int[] position, int n) {
        return position[0] > n || position[0] <= 0 || position[1] > n || position[1] <= 0;
    }

    static void Main(string[] args) {
        TextWriter textWriter = new StreamWriter(@System.Environment.GetEnvironmentVariable("OUTPUT_PATH"), true);

        string[] nk = Console.ReadLine().Split(' ');

        int n = Convert.ToInt32(nk[0]);

        int k = Convert.ToInt32(nk[1]);

        string[] r_qC_q = Console.ReadLine().Split(' ');

        int r_q = Convert.ToInt32(r_qC_q[0]);

        int c_q = Convert.ToInt32(r_qC_q[1]);

        int[][] obstacles = new int[k][];

        for (int i = 0; i < k; i++) {
            obstacles[i] = Array.ConvertAll(Console.ReadLine().Split(' '), obstaclesTemp => Convert.ToInt32(obstaclesTemp));
        }

        int result = queensAttack(n, k, r_q, c_q, obstacles);

        textWriter.WriteLine(result);

        textWriter.Flush();
        textWriter.Close();
    }
}
