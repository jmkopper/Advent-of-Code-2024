from collections import Set


@value
struct Lt(CollectionElement, KeyElement):
    var left: Int
    var right: Int

    fn __eq__(self, other: Self) -> Bool:
        return (self.left == other.left) and (self.right == other.right)

    fn __hash__(self) -> UInt:
        return hash(self.left) ^ hash(self.right)

    fn __ne__(self, other: Self) -> Bool:
        return (self.left != other.left) or (self.right != other.right)


alias Ordering = Set[Lt]


fn parse_order_data(order_data: List[String], inout ordering: Ordering) raises:
    for line in order_data:
        var s = line[].split("|")
        var entry = Lt(int(s[0]), int(s[1]))
        ordering.add(entry)


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


fn is_sorted(update: List[Int], ordering: Ordering) -> Bool:
    for i in range(len(update)):
        for j in range(i, len(update)):
            var left = update[i]
            var right = update[j]
            if Lt(right, left) in ordering:
                return False
    return True


fn qsort(arr: List[Int], ordering: Ordering) -> List[Int]:
    if len(arr) < 2:
        return arr

    pivot = arr[len(arr) // 2]
    lefts = List[Int]()
    middle = List[Int]()
    rights = List[Int]()

    for x in arr:
        if Lt(x[], pivot) in ordering:
            lefts.append(x[])
        elif Lt(pivot, x[]) in ordering:
            rights.append(x[])
        else:
            middle.append(x[])

    return qsort(lefts, ordering) + middle + qsort(rights, ordering)


fn part1(update_lines: List[List[Int]], ordering: Ordering) -> Int:
    var s = 0
    for line in update_lines:
        if is_sorted(line[], ordering):
            var mid = len(line[]) // 2
            s += line[][mid]
    return s


fn part2(update_lines: List[List[Int]], ordering: Ordering) -> Int:
    var s = 0
    for line in update_lines:
        if is_sorted(line[], ordering):
            continue
        var sorted_line = qsort(line[], ordering)
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
    var ordering = Ordering()
    parse_order_data(order_data, ordering)

    print("Part 1: ", part1(updates, ordering))
    print("Part 2: ", part2(updates, ordering))
