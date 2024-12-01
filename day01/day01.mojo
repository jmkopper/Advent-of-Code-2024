from collections import Dict


fn qsort(arr: List[Int]) -> List[Int]:
    if len(arr) < 2:
        return arr

    pivot = arr[len(arr) // 2]
    lefts = List[Int]()
    middle = List[Int]()
    rights = List[Int]()

    for x in arr:
        if x[] < pivot:
            lefts.append(x[])
        elif x[] > pivot:
            rights.append(x[])
        else:
            middle.append(x[])

    return qsort(lefts) + middle + qsort(rights)


fn part1(lefts: List[Int], rights: List[Int]) -> Int:
    var sum = 0
    var lsorted = qsort(lefts)
    var rsorted = qsort(rights)
    for i in range(len(lsorted)):
        sum += abs(lsorted[i] - rsorted[i])

    return sum


fn part2(lefts: List[Int], rights: List[Int]) -> Int:
    var d = Dict[Int, Int]()
    for k in lefts:
        d[k[]] = 0

    for k in rights:
        var q = d.get(k[])
        if q:
            d[k[]] = q.value() + 1

    var sum = 0
    for k in d.items():
        sum += k[].key * k[].value

    return sum


fn main() raises:
    var lines = List[String]()
    with open("input.txt", "r") as f:
        lines = f.read().strip().split("\n")

    var lefts = List[Int]()
    var rights = List[Int]()

    for row in lines:
        var q = row[].split()
        lefts.append(atol(q[0]))
        rights.append(atol(q[1]))

    print("Part 1: ", part1(lefts, rights))
    print("Part 2: ", part2(lefts, rights))
