#!/bin/python3

import os
import sys

names = {'words': 0}
#
# Complete the contacts function below.
#
def contacts(queries):
    results = []
    for query in queries:
        if query[0] == 'add':
            words = 0
            name = query[1]
            names['words'] += 1
            name_dict = names
            for letter in name:
                if not letter in name_dict:
                    name_dict[letter] = {'words': 0}
                name_dict = name_dict[letter]
                name_dict['words'] += 1
        elif query[0] == 'find':
            if len(query) == 1:
                results.append(names['words']) 
            else:
                partial = query[1]
                name_dict = names
                for letter in partial:
                    if letter in name_dict:
                        name_dict = name_dict[letter]
                    else:
                        name_dict = None
                        break
                
                if not name_dict:
                    results.append(0)
                else:
                    results.append(name_dict['words'])
    return results


if __name__ == '__main__':
    fptr = open(os.environ['OUTPUT_PATH'], 'w')

    queries_rows = int(input())

    queries = []

    for _ in range(queries_rows):
        queries.append(input().rstrip().split())

    result = contacts(queries)

    fptr.write('\n'.join(map(str, result)))
    fptr.write('\n')

    fptr.close()
