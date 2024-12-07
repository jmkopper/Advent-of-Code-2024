fn parse_line(line: String) raises -> List[Int]:
    var s = line.strip().split(":")
    var t = s[1].strip().split()
    var res = List[Int](int(s[0]))
    for v in t:
        res.append(int(v[]))
    return res


fn try_ops(
    line: List[Int], target: Int, idx: Int, acc: Int, try_concat: Bool = False
) -> Bool:
    if idx >= len(line):
        return target == acc

    if try_ops(line, target, idx + 1, acc + line[idx], try_concat):
        return True
    if try_ops(line, target, idx + 1, acc * line[idx], try_concat):
        return True
    if try_concat:
        var concat = (acc * (10 ** count_digits(line[idx]))) + line[idx]
        return try_ops(line, target, idx + 1, concat, try_concat)
    else:
        return False


fn count_digits(a: Int) -> Int:
    if a == 0:
        return 1
    var b = a
    var cnt = 0
    while b > 0:
        b //= 10
        cnt += 1
    return cnt


fn part1(lines: List[List[Int]]) -> Int:
    var res = 0
    for line in lines:
        var line_der = line[]
        if try_ops(line_der, line_der[0], 2, line_der[1]):
            res += line_der[0]
    return res


fn part2(lines: List[List[Int]]) -> Int:
    var res = 0
    for line in lines:
        var line_der = line[]
        if try_ops(line_der, line_der[0], 2, line_der[1], True):
            res += line_der[0]
    return res


fn main() raises:
    var text: List[String]
    with open("input.txt", "r") as f:
        text = f.read().strip().split("\n")

    var lines = List[List[Int]]()
    for line in text:
        lines.append(parse_line(line[]))

    print("Part 1: ", part1(lines))
    print("Part 2: ", part2(lines))
