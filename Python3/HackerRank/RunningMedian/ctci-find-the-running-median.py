#!/bin/python3

import math
import os
import random
import re
import sys

def insertIntoSortedList(list, val):    
    start = 0
    end = len(list)
    while start < end:
        mid = int((end - start)/2) + start
        if list[mid] > val:
            end = mid - 1
        elif list[mid] < val:
            start = mid + 1
        else:
            list.insert(mid, val)
            return
    
    if len(list) == 0 or start == len(list) or list[start] > val:
        list.insert(start, val)
    else:
        list.insert(start+1, val)
        
def getMedian(list):
    mid = int(len(list)/2)
    if len(list) % 2 == 1:
        return list[mid]
    return (list[mid-1] + list[mid]) / 2

if __name__ == '__main__':
    n = int(input())
    sortedList = []
    
    for _ in range(n):
        a_item = int(input())
        insertIntoSortedList(sortedList, a_item)
        print ("%.1f" % getMedian(sortedList))
        
        
