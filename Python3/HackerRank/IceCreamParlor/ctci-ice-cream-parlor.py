#!/bin/python3

import math
import os
import random
import re
import sys

# Complete the whatFlavors function below.
def whatFlavors(cost, money):
    matches = {}
    for i, price in enumerate(cost):
        diff = money - price
        if diff <= 0:
            continue
        if diff in matches:
            match = matches[diff]
            if i < match:
                print(str(i+1) + " " + str(match+1))
            else:
                print(str(match+1) + " " + str(i+1))                    
            return        
        matches[price] = i

if __name__ == '__main__':
    t = int(input())
    for t_itr in range(t):
        money = int(input())
        n = int(input())
        cost = list(map(int, input().rstrip().split()))
        whatFlavors(cost, money)

