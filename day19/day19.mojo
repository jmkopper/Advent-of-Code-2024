from collections import Dict, Set


fn num_possible(
    pattern: String, towels: List[String], inout memo: Dict[String, Int]
) raises -> Int:
    if pattern in memo:
        return memo[pattern]
    var c = 0
    for t in towels:
        if pattern.startswith(t[]):
            c += num_possible(pattern[len(t[]) :], towels, memo)
    memo[pattern] = c
    return c


fn part1(
    patterns: List[String], towels: List[String], inout memo: Dict[String, Int]
) raises -> Int:
    var c = 0
    for p in patterns:
        if num_possible(p[], towels, memo) > 0:
            c += 1
    return c


fn part2(
    patterns: List[String], towels: List[String], inout memo: Dict[String, Int]
) raises -> Int:
    var c = 0
    for p in patterns:
        c += num_possible(p[], towels, memo)
    return c


fn main() raises:
    var chunks: List[String]
    with open("input.txt", "r") as f:
        chunks = f.read().strip().split("\n\n")
    var towels = chunks[0].split(", ")
    var patterns = chunks[1].strip().splitlines()

    var max_length = 0
    for p in patterns:
        max_length = max(max_length, len(p[]))

    var memo = Dict[String, Int]()
    memo[""] = 1
    print("Part 1:", part1(patterns, towels, memo))
    print("Part 2:", part2(patterns, towels, memo))
