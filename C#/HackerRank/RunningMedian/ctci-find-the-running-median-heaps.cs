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


public enum HeapType
{
    Min,
    Max
}

public class Heap
{
    private readonly HeapType heapType;
    private int capacity;
    private int size = 0;
    private int[] items;

    public Heap(HeapType heapType, int initialCapacity)
    {
        this.heapType = heapType;
        this.capacity = initialCapacity;
        this.items = new int[this.capacity];
    }

    public int Size { get { return size; } }

    public int Peek()
    {
        if (size == 0) throw new InvalidOperationException("Heap is empty");
        return items[0];
    }

    public int Poll()
    {
        if (size == 0) throw new InvalidOperationException("Heap is empty");
        var item = items[0];
        items[0] = items[size - 1];
        size--;
        HeapifyDown();
        return item;
    }

    public void Add(int item)
    {
        EnsureExtraCapcity();
        items[size] = item;
        size++;
        HeapifyUp();
    }

    private int GetLeftChildIndex(int parentIndex) { return 2 * parentIndex + 1; }
    private int GetRightChildIndex(int parentIndex) { return 2 * parentIndex + 2; }
    private int GetParentIndex(int childIndex) { return (childIndex - 1) / 2; }

    private bool HasLeftChild(int index) { return GetLeftChildIndex(index) < size; }
    private bool HasRightChild(int index) { return GetRightChildIndex(index) < size; }
    private bool HasParent(int index) { return GetParentIndex(index) >= 0; }

    private int LeftChild(int index) { return items[GetLeftChildIndex(index)]; }
    private int RightChild(int index) { return items[GetRightChildIndex(index)]; }
    private int Parent(int index) { return items[GetParentIndex(index)]; }

    private void Swap(int indexOne, int indexTwo)
    {
        int temp = items[indexOne];
        items[indexOne] = items[indexTwo];
        items[indexTwo] = temp;
    }

    private void EnsureExtraCapcity()
    {
        if (size == capacity)
        {
            var newItems = new int[capacity * 2];
            Array.Copy(items, newItems, capacity * 2);
            items = newItems;
            capacity *= 2;
        }
    }

    private void HeapifyDown()
    {
        var index = 0;
        if (heapType.Equals(HeapType.Min))
        {
            while (HasLeftChild(index))
            {
                var smallerChildIndex = GetLeftChildIndex(index);
                if (HasRightChild(index) && RightChild(index) < LeftChild(index))
                {
                    smallerChildIndex = GetRightChildIndex(index);
                }

                if (items[index] < items[smallerChildIndex])
                {
                    break;
                }
                else
                {
                    Swap(index, smallerChildIndex);
                    index = smallerChildIndex;
                }
            }
        }
        else if (heapType.Equals(HeapType.Max))
        {
            while (HasLeftChild(index))
            {
                var largerChildIndex = GetLeftChildIndex(index);
                if (HasRightChild(index) && RightChild(index) > LeftChild(index))
                {
                    largerChildIndex = GetRightChildIndex(index);
                }

                if (items[index] > items[largerChildIndex])
                {
                    break;
                }
                else
                {
                    Swap(index, largerChildIndex);
                    index = largerChildIndex;
                }
            }
        }
    }

    private void HeapifyUp()
    {
        var index = size - 1;
        while (HasParent(index) && (heapType.Equals(HeapType.Max)
                ? (Parent(index) < items[index])
                : (Parent(index) > items[index])))
        {
            Swap(GetParentIndex(index), index);
            index = GetParentIndex(index);
        }
    }
}

class HeapManager
{
    private readonly Heap minHeap;
    private readonly Heap maxHeap;

    public HeapManager(int totalCapacity)
    {
        // Set up the heaps to have an initial capacity of one more than 
        // half the quantity of numbers we expect - this way neither heap 
        // will exceed its capacity as we keep them balanced
        var halfTotal = (totalCapacity + 2) / 2;
        minHeap = new Heap(HeapType.Min, halfTotal);
        maxHeap = new Heap(HeapType.Max, halfTotal);
    }

    public double GetMedian()
    {
        if (maxHeap.Size > minHeap.Size)
        {
            return maxHeap.Peek();
        }
        else if (maxHeap.Size < minHeap.Size)
        {
            return minHeap.Peek();
        }
        else
        {
            return ((double)minHeap.Peek() + maxHeap.Peek()) / 2;
        }
    }

    public void Add(int val)
    {
        // Just default to adding to the max heap for the first item
        if (maxHeap.Size == 0)
        {
            maxHeap.Add(val);
            return;
        }

        // The median is currently in the maxHeap
        if (maxHeap.Size > minHeap.Size)
        {
            // New should go in the maxHeap if it is less than the current median
            if (val < maxHeap.Peek())
            {
                maxHeap.Add(val);
                // Rebalance the heaps
                minHeap.Add(maxHeap.Poll());
            }
            else
            {
                minHeap.Add(val);
            }
        }
        // The median is currently in the minHeap
        else if (maxHeap.Size < minHeap.Size)
        {
            if (val > minHeap.Peek())
            {
                minHeap.Add(val);
                // Rebalance the heaps
                maxHeap.Add(minHeap.Poll());
            }
            else
            {
                maxHeap.Add(val);
            }
        }
        // The median is split evenly between the two heaps
        else
        {
            var currentMedian = ((double)minHeap.Peek() + maxHeap.Peek()) / 2;
            if (val > currentMedian)
            {
                minHeap.Add(val);
            }
            else
            {
                maxHeap.Add(val);
            }
        }
    }
}

class Solution 
{
    static void Main(string[] args)
    {
        int n = Convert.ToInt32(Console.ReadLine());
        var heapManager = new HeapManager(n);
        for (int i = 0; i < n; i++)
        {
            int aItem = Convert.ToInt32(Console.ReadLine());
            heapManager.Add(aItem);
            var median = heapManager.GetMedian();
            Console.WriteLine(median.ToString("F01"));
        }
    }
}
