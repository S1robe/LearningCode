# Find all palindromic substrings of a given string

string = input('What is your string to search? Any characters supported.')


# First way I can think of to do this 9/11/22 ~ O(N^3) N = len(streng)
def findLongestPalenString(streng):
    maxLength = 1           # Everything of length 1 is technically a palindrome
    start = 0
    for i in range(len(streng)):
        for j in range(i, len(streng)):
            flag = 1

            for k in range(0, ((j-i)//2)+1):
                if streng[i+k] != streng[j-k]:
                    flag = 0

            if flag and (j - i + 1) > maxLength:
                start = i
                maxLength = j-i+1

    print(f'Longest palindrome is : \n{streng[start:start+maxLength-1]}')


# First realizaiton, palendromes, make other palendromes, so if I find the longest, I may also have all of them.
