fn parse_line(line: String) raises -> List[Int]:
    var s = line.split()
    var res = List[Int]()
    for c in s:
        res.append(atol(c[]))

    return res


fn is_safe(line: List[Int]) -> Int:
    var diffs = List[Int]()
    for i in range(len(line) - 1):
        diffs.append(line[i + 1] - line[i])

    for d in diffs:
        if d[] * diffs[0] < 0:
            return False

        if abs(d[]) < 1 or abs(d[]) > 3:
            return False

    return True


fn is_safe2(inout line: List[Int]) -> Int:
    for i in range(len(line)):
        var t = line.pop(i)
        if is_safe(line):
            return True
        line.insert(i, t)

    return False


fn part1(lines: List[List[Int]]) -> Int:
    var ct = 0
    for line in lines:
        if is_safe(line[]):
            ct += 1

    return ct


fn part2(inout lines: List[List[Int]]) -> Int:
    var ct = 0
    for line in lines:
        if is_safe2(line[]):
            ct += 1

    return ct


fn main() raises:
    var lines = List[String]()
    with open("input.txt", "r") as f:
        lines = f.read().strip().split("\n")

    var lines_int = List[List[Int]]()
    for line in lines:
        lines_int.append(parse_line(line[]))

    print("Part 1: ", part1(lines_int))
    print("Part 2: ", part2(lines_int))
