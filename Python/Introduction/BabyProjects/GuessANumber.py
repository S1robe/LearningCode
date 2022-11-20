import random

cont = True
while cont:
    choice = int(random.random() * 100 + 1)  # Gen Random 1-100
    guess = int(input('Try to guess my magic number (1-100)'))
    while guess != choice:
        if guess > choice:
            guess = int(input('That\'s a bit too high ;)'))
        if guess < choice:
            guess = int(input('That\'s a bit too low :('))
    guess = input('That\'s correct! Would you like to play again? (Y/n)')
    cont = (guess != 'n')

