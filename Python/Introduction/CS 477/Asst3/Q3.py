import timeit
import time


def fun(n):
    f = [0] * n
    for i in range(n):
        if i < 7:
            f[i] = 1
        else:
            f[i] = f[int(i / 2)] + f[int(i / 2) + 1] + f[int(i / 2) + 2] + f[int(i / 2) + 3] + i ^ 2


x = int(input())
sTime = timeit.default_timer()
fun(x * 1024)
print(timeit.default_timer() - sTime)
sTime = timeit.default_timer()
fun(x * 1024*2)
print(timeit.default_timer() - sTime)
