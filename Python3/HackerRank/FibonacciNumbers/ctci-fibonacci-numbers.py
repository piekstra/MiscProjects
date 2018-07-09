knownFibs = {0:0, 1:1}

def fibonacci(n):
    if n in knownFibs:
        return knownFibs[n]
    knownFibs[n] = fibonacci(n-1) + fibonacci(n-2)
    return knownFibs[n]
    # Write your code here.

n = int(input())
print(fibonacci(n))
