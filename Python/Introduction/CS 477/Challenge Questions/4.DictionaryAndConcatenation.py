# Given a dictionary and a word w, determine whether w is the concatenation of words in the dictionary.
# For this problem our upper bound is the words in the dictionary of length t, where t < len (w)
#
# Then must make lists of possible subwords/substrings from lengths 1-t, does lambda + w count as a word?
#

dictionary = {}
wordIn = input('What is your word to check')
