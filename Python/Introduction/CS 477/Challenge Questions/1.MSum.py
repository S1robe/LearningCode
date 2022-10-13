# Given an array of integers of length n and a value m, determine whether there are any two integers in
# that array whose sum is m.
# You can easily prove that the time complexity of this problem is Ω(n), since you might have to look at
# every entry. I can solve it in O(n log n) time. Can it be done faster? I don’t know
import random

#is there some n1 & n2 such that n1 + n2 = m

n = int(input('How many random integers from 1-10 would you like?'))
lst = []
found = False
# Generate n random values
for i in range(0, n):
    lst.append(int(random.random() * 25 + 1))
print(lst)

m = int(input('What sum should we check for?'))

# Omega(n) way
# for i in (0, n - 1):
#     for j in (1, n - 1):
#         if (lst[i] + lst[j]) == m:
#             print(f'Sum of {m} found at {i},{j} : {lst[i]} + {lst[j]} = {m}')
#             found = True
#             break
# if not found:
#     print(f'Sum of {m} not present in the list.')

# lst.sort()
# O(n log n)
# I first assume the list is sorted since hthe task we are measuring is not the sort, but finding the sum
# From a sorted list, I pick all elements, then binary search for the difference from the sum, that is:
# For each X, binSearch(S - x)
# sumIndex = -1
# for x in lst:
#     lo = 0
#     hi = len(lst) - 1
#     mid = 0
#     while lo <= hi:
#         mid = hi + lo // 2
#         if lst[mid] < x:
#             lo = mid + 1
#         elif lst[mid] > x:
#             hi = mid - 1
#         else:
#             print(f'Sum of {m} found between {x} + {lst[mid]}')
#             break


# O(n) time
# We have to cheat in a way, and use a hash table
# for a hash table of size (n), any place accessed via a hash is done so in O(n)
# so we pick a random x from our hash table, then look for S - x again from our hash table
# we use a size n table for n values because the load factor of the hash is n/m which is O(1)
# therefore each element gets represented once, duplicates are allowed, and simple map to the same place,
# since they're the same value, this can be allowed.
# Function to display hashtable
def display(hashTable):
    for i in range(len(hashTable)):
        print(i, end=" ")

        for j in hashTable[i]:
            print("-->", end=" ")
            print(j, end=" ")
        print()


# Creating Hashtable as a nested list.
HashTable = [[] for _ in range(n)]

# Hashing Function to return key any every value.
def hash_elem(keyvalue):
    return keyvalue % len(HashTable)

# Insert Function to add
# values to the hash table
def insert(Hashtable, keyvalue, value):
    hash_key = hash_elem(keyvalue)
    Hashtable[hash_key].append(value)

def find(Hashtable, value):
    hash_key = hash_elem(value)
    return Hashtable[hash_key]

for x in lst:
    insert(HashTable, x, x)

display(HashTable)
for x in lst:
    found = find(HashTable, m-x)            # look for m-x
    if len(found) >= 1 and found.count(m-x) > 1:
        print(f'({x} ,{found})')
        break



