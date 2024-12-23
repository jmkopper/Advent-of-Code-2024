from collections import defaultdict

NUM_ITER = 2000


def calculate_secret(s):
    s = (s ^ (s * 64)) % 16777216
    s = (s ^ (s // 32)) % 16777216
    s = (s ^ (s * 2048)) % 16777216
    return s


def repeat_secret(s):
    res = [s]
    for _ in range(NUM_ITER):
        res.append(calculate_secret(res[-1]))
    return res


def calculate_diffs(s):
    res = [x % 10 for x in repeat_secret(s)]
    return res[1:], [s - t for s, t in zip(res[1:], res)]


def form_seqs(secret, best):
    p, d = calculate_diffs(secret)
    seen = set()
    for i in range(len(d) - 4):
        nxt = (d[i], d[i + 1], d[i + 2], d[i + 3])
        if nxt in seen:
            continue
        best[nxt] += p[i + 3]
        seen.add(nxt)


def part1(buyers):
    return sum(r[-1] for r in (repeat_secret(s) for s in buyers))


def part2(buyers):
    best = defaultdict(int)
    for b in buyers:
        form_seqs(b, best)
    return max(best.values())


def main():
    with open("input.txt", "r") as f:
        lines = [int(x) for x in f.read().splitlines()]

    print("Part 1: ", part1(lines))
    print("Part 2: ", part2(lines))


if __name__ == "__main__":
    main()
