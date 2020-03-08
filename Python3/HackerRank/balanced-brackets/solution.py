#!/bin/python3

import math
import os
import random
import re
import sys

# Complete the isBalanced function below.
def isBalanced(s):
    if not s:
        return 'YES'

    expected_brackets = []
    for char in s:
        if char == '{':
            expected_brackets.append('}')
        elif char == '[':
            expected_brackets.append(']')
        elif char == '(':
            expected_brackets.append(')')
        else:
            if len(expected_brackets) == 0:
                return 'NO'
            expected = expected_brackets.pop()
            if char != expected:
                return 'NO'
    
    if len(expected_brackets) > 0:
        return 'NO'

    return 'YES'


if __name__ == '__main__':
    fptr = open(os.environ['OUTPUT_PATH'], 'w')

    t = int(input())

    for t_itr in range(t):
        s = input()

        result = isBalanced(s)

        fptr.write(result + '\n')

    fptr.close()
