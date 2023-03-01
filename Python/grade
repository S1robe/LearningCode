#!/bin/python

import os.path
import sys
import re
import subprocess as subp

passBoardMsg = "(Thread $x: Wooh! I’m about to ride the roller coaster for the (?:(?:([1-9]|[1-9]+0)*1 st)|(?:(?:[1-9]|[1-9]+0)*2 nd)|(?:(?:[1-9]|[1-9]+0)*3 rd)|(?:(?:[1-9]|[1-9]+0)*[4-9] th)) time! I have (?:[1-9]|[1-9]+0)*[1-9] iterations left\\.)"
passExitMsg = "(hread $x: Completed (?:[1-9]|[1-9]+0)*[1-9] iterations? on the roller coaster\\. Exiting\\.)"
rideBeginMsg = "(Car: (?:[1-9]|[1-9]+0)*[0-9] passenger(?: is|s are) riding the roller coaster\\. Off we go on the (?:[1-9]|[1-9]+0)*[1-9] ride!)"
rideCompleteMsg = "(Car:  ride (?:[1-9]|[1-9]+0)*[1-9]  completed\\.)"
progExit = "(Car: Roller coaster shutting down\\.)"


# finds all matching strings according to @refPattern
def getOutput(refPattern: str, outp: str):
    return re.findall(refPattern, outp, flags=re.IGNORECASE)


def getNumIterations(exitStr: str):
    sub = re.findall("(?:[1-9]|[1-9]+0)*[1-9] iterations", exitStr)
    return int(sub[0][0:sub[0].index(" ")])


argc = len(sys.argv)
if argc < 2:
    print("Usage: ./grade <filename (txt or exe)> <# n> <# c> <# i>")
    exit(1)

filename = sys.argv[1]  # this script will run the provided named
n = int(sys.argv[2])
c = int(sys.argv[3])
i = int(sys.argv[4])

if os.path.exists("./" + filename):
    filename = "./" + filename
elif os.path.exists(filename):
    pass
else:
    print("Cant find ", filename)
    exit(1)

args = list([filename, "-n", str(n), "-c", str(c), "-i", str(i)])
isExec = os.access(filename, os.X_OK)

try:
    pout = ""
    if isExec:
        pout = subp.check_output(args, text=True)
    else:
        pout = "".join(open(filename, "r").readlines())

    rideLim = 0
    if (n * i) % c == 0:
        rideLim = int(((n * i) / c) + c)
    else:
        rideLim = int(((n * i) / c) + (c - ((n * i) % c)))
    # n*i "people" to serve, with c seats, therefore (n*i)/c rides,
    # + i for the average amt of times it runs < than c
    passBoardMsgs = list()
    passCompleteMsgs = list()

    for x in range(n):
        passCompleteMsgs.append(getOutput(passExitMsg.replace("$x", str(x)), pout))  # count exit times
        if len(passCompleteMsgs[x]) > 1:
            print("Passenger", x, "exited more than once!")
            exit(1)
        elif len(passCompleteMsgs[x]) == 0:
            print("Passenger", x, "never left the park!")
            exit(1)

        numIterations = getNumIterations(passCompleteMsgs[x][0])  # Returns the choice from the random variable (0, i)
        passBoardMsgs.append(list(set(getOutput(passBoardMsg.replace("$x", str(x)),
                                                pout))))  # Matches all times the passenger gets on the coaster

        if len(passBoardMsgs[x]) != numIterations:
            print("Passenger", x, "did not run", numIterations, "iterations.")
            exit(1)

    rBegCnt = len(getOutput(rideBeginMsg, pout))
    if not (0 <= rBegCnt <= rideLim):
        print("Invalid amount of rides possible.\n", "Expected: ", rideLim, "\nGot: ", rBegCnt)
        exit(1)

    rEndCnt = len(getOutput(rideCompleteMsg, pout))
    if rBegCnt > rEndCnt:
        print("The ride never stopped with passengers on it!")
        exit(1)
    elif rBegCnt < rEndCnt:
        print("The ride ended before it began!")
        exit(1)

    if len(getOutput(progExit, pout)) != 1:
        print("The ride never shutdown!")
        exit(1)


except subp.CalledProcessError as rproc:  # returned process
    # Process returned non-zero error code
    print("Something has gone horribly wrong!")
    exit(1)

except OSError as oerr:
    print("File could not be read for testing ", filename, " :(")
    exit(1)

print("All test passed!")
exit(0)
