import time
import random

diction = {}
lilo = []


def search1(listoflists, key):
    for li in listoflists:
        if key == li[0]:
            return li[0]
    return ""


def search2(dictionary, key):
    return dictionary.get(key)


def populate():
    global lilo, diction
    for i in range(0, 1000):
        lilo.append([i, i])
    random.shuffle(lilo)
    diction = dict(lilo)


def begin():
    global lilo, diction
    populate()

    key = range(0, 1000)

    start = time.time() * 1000.0
    search1(lilo, key)
    end = time.time() * 1000.0
    print("search1 (Loli): ", (end - start))

    start = time.time() * 1000.0
    search2(diction, key)
    end = time.time() * 1000.0
    print("search2 (dict): ", (end - start))


begin()
