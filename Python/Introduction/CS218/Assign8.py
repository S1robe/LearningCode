# Shell Sort
lst = [1113, 1232, 2146, 1376, 5120, 2356, 164, 4565, 155, 3157
    , 759, 326, 171, 147, 5628, 7527, 7569, 177, 6785, 3514
    , 1001, 128, 1133, 1105, 327, 101, 115, 1108, 1, 115
    , 1227, 1226, 5129, 117, 107, 105, 109, 999, 150, 414
    , 107, 6103, 245, 6440, 1465, 2311, 254, 4528, 1913, 6722
    , 1149, 126, 5671, 4647, 628, 327, 2390, 177, 8275, 614
    , 3121, 415, 615, 122, 7217, 1, 410, 1129, 812, 2134
    , 221, 2234, 151, 432, 114, 1629, 114, 522, 2413, 131
    , 5639, 126, 1162, 441, 127, 877, 199, 679, 1101, 3414
    , 2101, 133, 1133, 2450, 532, 8619, 115, 1618, 9999, 115
    , 219, 3116, 612, 217, 127, 6787, 4569, 679, 675, 4314
    , 1104, 825, 1184, 2143, 1176, 134, 4626, 100, 4566, 346
    , 1214, 6786, 617, 183, 512, 7881, 8320, 3467, 559, 1190
    , 103, 112, 1, 2186, 191, 86, 134, 1125, 5675, 476
    , 5527, 1344, 1130, 2172, 224, 7525, 100, 1, 100, 1134
    , 181, 155, 1145, 132, 167, 185, 150, 149, 182, 434
    , 581, 625, 6315, 1, 617, 855, 6737, 129, 4512, 1
    , 177, 164, 160, 1172, 184, 175, 166, 6762, 158, 4572
    , 6561, 283, 1133, 1150, 135, 5631, 8185, 178, 1197, 185
    , 649, 6366, 1162, 167, 167, 177, 169, 1177, 175, 1169]

h = 1
while (h * 3 + 1) < 200:
    h = 3 * h + 1

while h > 0:
    i = h - 1
    while i < 200:
        tmp = lst[i]
        j = i
        while (j >= h) and (lst[j - h] < tmp):
            lst[j] = lst[j - h]
            j = j - h
        lst[j] = tmp
        i = i + 1
    h = h // 3
print(lst)
