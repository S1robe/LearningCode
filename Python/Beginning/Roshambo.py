import random
from enum import Enum


class Choices(Enum):
    rock = 0
    paper = 1
    scissors = 2

    def beats(self, other):
        return Choices(other).value is ((self.value + 2) % 3)
        # return Choices.__dict__[(self.value + 2) % 3]


ino = input("Pick your roll:\n1. Rock\n2. Paper\n3. Scissors\n4. Exit\n").lower()
while ino not in ["4", "exit"]:
    valid = False
    if ino in ["1", "rock"]:
        ino = Choices.rock
        valid = True
    elif ino in ["2", "paper"]:
        ino = Choices.paper
        valid = True
    elif ino in ["3", "scissors"]:
        ino = Choices.scissors
        valid = True

    if valid:
        com = random.choice(list(Choices))
        print("Computer chose", com.name)
        print("You chose", ino.name)
        if com.beats(ino):
            print("You lose!")
        elif ino.beats(com):
            print("You win!")
        else:
            print("Tie!")
    ino = input("Pick your roll:\n1. Rock\n2. Paper\n3. Scissors\n4. Exit\n").lower()

