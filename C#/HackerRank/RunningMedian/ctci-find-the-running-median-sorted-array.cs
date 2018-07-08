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
    private static void InsertIntoSortedList(List<int> sortedList, int val) 
    {
        var start = 0;
        var end = sortedList.Count;
        while (start < end) 
        {
            var mid = (end - start)/2 + start;
            if (sortedList[mid] > val) 
                end = mid - 1;
            else if (sortedList[mid] < val) 
                start = mid + 1;
            else 
            {
                sortedList.Insert(mid, val);
                return;
            }
        }

        if (sortedList.Count == 0 || start == sortedList.Count || sortedList[start] > val)
            sortedList.Insert(start, val);
        else
            sortedList.Insert(start+1, val);
    }

    private static double GetMedian(List<int> sortedList)
    {
        var mid = sortedList.Count / 2;
        if (sortedList.Count % 2 == 1)
            return sortedList[mid];
        return ((double)sortedList[mid-1] + sortedList[mid]) / 2;
    }
            
    static void Main(string[] args)
    {
        int n = Convert.ToInt32(Console.ReadLine());
        var sortedList = new List<int>();
        for (int i = 0; i < n; i++)
        {
            int aItem = Convert.ToInt32(Console.ReadLine());
            InsertIntoSortedList(sortedList, aItem);
            Console.WriteLine(GetMedian(sortedList).ToString("F01"));
        }
    }
}
