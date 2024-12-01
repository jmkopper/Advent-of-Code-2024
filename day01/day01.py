def part1(lefts, rights):
    return sum(abs(left - right) for left, right in zip(sorted(lefts), sorted(rights)))


def part2(lefts, rights):
    d = {left: 0 for left in lefts}
    for k in rights:
        if k in d:
            d[k] += 1

    return sum(k * v for k, v in d.items())


if __name__ == "__main__":
    with open("input.txt", "r") as f:
        lines = f.readlines()
    lefts = [int(s.split()[0]) for s in lines]
    rights = [int(s.split()[1]) for s in lines]

    print("Part 1: ", part1(lefts, rights))
    print("Part 2: ", part2(lefts, rights))
