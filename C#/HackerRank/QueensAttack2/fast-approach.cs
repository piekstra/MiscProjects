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

    // Complete the queensAttack function below.
    static int queensAttack(int n, int k, int r_q, int c_q, int[][] obstacles)
    {
        // First start out assuming no obstacles on the board
        // Set the obstacles as the first spot off the board in each direction        
        // The cardinal directions are easy, but diagonals are more complicated
        int[] upRight;
        int[] downRight;
        int[] upLeft;
        int[] downLeft;

        var npo = n + 1;
        var rpc = r_q + c_q;

        /*
            > > =
            > = <
            = < <  
        */
        if (r_q <= c_q)
        {
            var cmr = c_q - r_q;
            upRight = new int[] { npo - cmr, npo };
            downLeft = new int[] { 0, cmr };
        }
        else
        {
            var rmc = r_q - c_q;
            upRight = new int[] { npo, npo - rmc };
            downLeft = new int[] { rmc, 0 };
        }

        /*
            = > >
            < = >
            < < =
        */
        if (rpc <= n)
        {
            upLeft = new int[] { rpc, 0 };
            downRight = new int[] { 0, rpc };
        }
        else
        {
            upLeft = new int[] { npo, rpc - npo };
            downRight = new int[] { rpc - npo, npo };
        }

        var pathObstacles = new int[8][] {
            new int[] {0, c_q},     // Down
            new int[] {n+1, c_q},   // Up
            new int[] {r_q, 0},     // Left
            new int[] {r_q, n+1},   // Right   
            upRight,                // Up right      
            downRight,              // Down right     
            upLeft,                 // Up left     
            downLeft,               // Down left        
        };

        // Indexes for the "paths"
        var di = 0;
        var ui = 1;
        var li = 2;
        var ri = 3;
        var uri = 4;
        var dri = 5;
        var uli = 6;
        var dli = 7;

        // Now that we have out-of-bounds "obstacles", go through the actual list of
        // obstacles and set update each direction's obstacle to be the closest one
        // to the queen (any on the same path beyond that one don't matter)
        foreach (var obstacle in obstacles)
        {
            var r = obstacle[0];
            var c = obstacle[1];

            // down
            if (c == c_q && r < r_q && r > pathObstacles[di][0])
            {
                pathObstacles[di] = obstacle;
            }
            // up
            else if (c == c_q && r > r_q && r < pathObstacles[ui][0])
            {
                pathObstacles[ui] = obstacle;
            }
            // left
            else if (r == r_q && c < c_q && c > pathObstacles[li][1])
            {
                pathObstacles[li] = obstacle;
            }
            // right
            else if (r == r_q && c > c_q && c < pathObstacles[ri][1])
            {
                pathObstacles[ri] = obstacle;
            }
            // up right
            else if (c > c_q && r > r_q && c - c_q == r - r_q && r < pathObstacles[uri][0])
            {
                pathObstacles[uri] = obstacle;
            }
            // down right
            else if (c > c_q && r < r_q && c - c_q == r_q - r && r > pathObstacles[dri][0])
            {
                pathObstacles[dri] = obstacle;
            }
            // up left
            else if (c < c_q && r > r_q && c_q - c == r - r_q && r < pathObstacles[uli][0])
            {
                pathObstacles[uli] = obstacle;
            }
            // down left
            else if (c < c_q && r < r_q && c_q - c == r_q - r && r > pathObstacles[dli][0])
            {
                pathObstacles[dli] = obstacle;
            }
        }

        // Now we have narrowed down the obstacles to the relevant ones
        // Go through the paths and find the distance between each and
        // the queen, that number minus one will be the number of attacks
        // possible in that direction
        var attacks = 0;
        foreach (var pathObstacle in pathObstacles)
        {
            var a = Math.Abs(pathObstacle[0] - r_q);
            var b = Math.Abs(pathObstacle[1] - c_q);

            // Since the path directions are always cardinal or diagonal,
            // the greatest of a or b is the distance
            attacks += (a > b ? a : b) - 1;
        }

        return attacks;
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
