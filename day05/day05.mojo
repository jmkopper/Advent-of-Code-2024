from collections import Dict

alias Ordering = Dict[Int, List[Int]]


fn parse_order_data(order_data: List[String]) raises -> Ordering:
    var res = Ordering()
    for line in order_data:
        var s = line[].split("|")
        var left = int(s[0])
        var right = int(s[1])
        if left in res:
            res[left].append(right)
        else:
            res[left] = List(right)
    return res


fn parse_update(update_line: String) raises -> List[Int]:
    var s = update_line.split(",")
    var update_as_int = List[Int]()
    for c in s:
        update_as_int.append(int(c[]))
    return update_as_int


fn parse_updates(update_lines: List[String]) raises -> List[List[Int]]:
    var res = List[List[Int]]()
    for line in update_lines:
        res.append(parse_update(line[]))
    return res


fn is_sorted(update: List[Int], order_dict: Ordering) raises -> Bool:
    for i in range(len(update)):
        for j in range(i, len(update)):
            var left = update[i]
            var right = update[j]
            if right in order_dict:
                if left in order_dict[right]:
                    return False
    return True


fn lt(a: Int, b: Int, order_dict: Ordering) raises -> Bool:
    if a not in order_dict:
        return False
    if b in order_dict[a]:
        return True
    return False


fn qsort(arr: List[Int], order_dict: Ordering) raises -> List[Int]:
    if len(arr) < 2:
        return arr

    pivot = arr[len(arr) // 2]
    lefts = List[Int]()
    middle = List[Int]()
    rights = List[Int]()

    for x in arr:
        if lt(x[], pivot, order_dict):
            lefts.append(x[])
        elif lt(pivot, x[], order_dict):
            rights.append(x[])
        else:
            middle.append(x[])

    return qsort(lefts, order_dict) + middle + qsort(rights, order_dict)


fn part1(update_lines: List[List[Int]], order_dict: Ordering) raises -> Int:
    var s = 0
    for line in update_lines:
        if is_sorted(line[], order_dict):
            var mid = len(line[]) // 2
            s += line[][mid]
    return s


fn part2(update_lines: List[List[Int]], order_dict: Ordering) raises -> Int:
    var s = 0
    var i = 0
    for line in update_lines:
        i += 1
        if is_sorted(line[], order_dict):
            continue
        var sorted_line = qsort(line[], order_dict)
        var mid = len(sorted_line) // 2
        s += sorted_line[mid]
    return s


fn main() raises:
    var chunks: List[String]
    with open("input.txt", "r") as f:
        chunks = f.read().strip().split("\n\n")
    var order_data = chunks[0].strip().splitlines()
    var update_data = chunks[1].strip().splitlines()

    var updates = parse_updates(update_data)
    var order_dict = parse_order_data(order_data)

    print("Part 1: ", part1(updates, order_dict))
    print("Part 2: ", part2(updates, order_dict))
