from collections import deque
from functools import cache

UP = "^"
RIGHT = ">"
DOWN = "v"
LEFT = "<"
A_KEY = "A"

DIR_NEIGHBORS = {
    UP: [(DOWN, DOWN), (A_KEY, RIGHT)],
    RIGHT: [(DOWN, LEFT), (A_KEY, UP)],
    DOWN: [(UP, UP), (LEFT, LEFT), (RIGHT, RIGHT)],
    LEFT: [(DOWN, RIGHT)],
    A_KEY: [(UP, LEFT), (RIGHT, DOWN)],
}


NUM_NEIGHBORS = {
    "9": [("8", LEFT), ("6", DOWN)],
    "8": [("5", DOWN), ("7", LEFT), ("9", RIGHT)],
    "7": [("8", RIGHT), ("4", DOWN)],
    "6": [("3", DOWN), ("5", LEFT), ("9", UP)],
    "5": [("2", DOWN), ("4", LEFT), ("6", RIGHT), ("8", UP)],
    "4": [("1", DOWN), ("5", RIGHT), ("7", UP)],
    "3": [(A_KEY, DOWN), ("2", LEFT), ("6", UP)],
    "2": [("0", DOWN), ("1", LEFT), ("3", RIGHT), ("5", UP)],
    "1": [("2", RIGHT), ("4", UP)],
    "0": [(A_KEY, RIGHT), ("2", UP)],
    A_KEY: [("0", LEFT), ("3", UP)],
}


def bfs(start, end, neighbors):
    q = deque([(start, "")])
    visited = {start}
    best = None
    res = []
    while len(q) > 0:
        u, p = q.popleft()
        if u == end:
            if best is None:
                best = len(p)
            if len(p) == best:
                res.append(p + A_KEY)
            continue
        if best is not None and len(p) >= best:
            continue
        for n, dir in neighbors[u]:
            visited.add(n)
            q.append((n, p + dir))
    return res


DIR_PAD_PATHS = {}
NUM_PAD_PATHS = {}

for i in DIR_NEIGHBORS:
    for j in DIR_NEIGHBORS:
        DIR_PAD_PATHS[(i, j)] = bfs(i, j, DIR_NEIGHBORS)

for i in NUM_NEIGHBORS:
    for j in NUM_NEIGHBORS:
        NUM_PAD_PATHS[(i, j)] = bfs(i, j, NUM_NEIGHBORS)


def do_num_pad(path, depth):
    res = 0
    cur = A_KEY
    for nxt in path:
        paths = NUM_PAD_PATHS[(cur, nxt)]
        if depth == 0:
            res += min(len(p) for p in paths)
        else:
            res += min(do_dir_pad(p, depth - 1) for p in paths)
        cur = nxt
    return res


@cache
def do_dir_pad(path, depth):
    res = 0
    cur = A_KEY
    for nxt in path:
        paths = DIR_PAD_PATHS[(cur, nxt)]
        if depth == 0:
            res += min(len(p) for p in paths)
        else:
            res += min(do_dir_pad(p, depth - 1) for p in paths)
        cur = nxt
    return res


def part1(nums):
    res = 0
    for num in nums:
        c = do_num_pad(num, 2)
        res += c * int(num[:3])
    return res


def part2(nums):
    res = 0
    for num in nums:
        c = do_num_pad(num, 25)
        res += c * int(num[:3])
    return res

def main():
    with open("input.txt", "r") as f:
        nums = f.read().splitlines()

    print("Part 1: ", part1(nums))
    print("Part 2: ", part2(nums))


if __name__ == "__main__":
    main()
