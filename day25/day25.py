with open("input.txt", "r") as f:
    chunks = [x.splitlines() for x in f.read().strip().split("\n\n")]

def parse_thing(c):
    return [max(j for j in range(7) if c[j][i] == "#") for i in range(5)]

locks = [parse_thing(c) for c in chunks if c[0][0] == "#"]
keys = [parse_thing(list(reversed(c))) for c in chunks if c[0][0] != "#"]
p = sum(1 for key in keys for lock in locks if max(a + b for a, b in zip(key, lock)) <= 5)

print("Part 1: ", p)
