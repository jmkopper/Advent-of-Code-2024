from collections import defaultdict, deque


def ncycles(graph, n):
    q = deque([[k] for k in graph])
    n_cycles = set()
    while q:
        u = q.popleft()
        if len(u) > n:
            return n_cycles
        head, tail = u[0], u[-1]
        if len(u) == n and head in graph[tail]:
            n_cycles.add(tuple(sorted(u)))
        for nbhr in graph[tail]:
            q.append(u + [nbhr])
    return n_cycles


def bron_kerbosch(g, r, p, x, cliques):
    if not p and not x:
        cliques[len(r)] = r
    while p:
        v = p.pop()
        next_p = [y for y in p if y in g[v]]
        next_x = [y for y in x if y in g[v]]
        bron_kerbosch(g, r + [v], next_p, next_x, cliques)
        x.append(v)
    return cliques


def part1(graph):
    return sum(1 for c in ncycles(graph, 3) if any(v.startswith("t") for v in c))


def part2(graph):
    q = bron_kerbosch(graph, [], list(graph.keys()), [], {})
    return ",".join(sorted(q[max(q)]))


def main():
    with open("input.txt", "r") as f:
        lines = f.read().splitlines()
    conns = [(s[0], s[1]) for s in [x.split("-") for x in lines]]
    g = defaultdict(set)
    for c in conns:
        g[c[0]].add(c[1])
        g[c[1]].add(c[0])
    print(f"Part 1: {part1(g)}")
    print(f"Part 2: {part2(g)}")


if __name__ == "__main__":
    main()
