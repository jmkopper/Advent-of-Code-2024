DIRS = [(0, 1), (0, -1), (-1, 0), (1, 0)]
def neighbors(grid, p):
    r, c = p
    return [
        (r + dr, c + dc) 
        for dr, dc in DIRS 
        if 0 <= r + dr < len(grid) and 0 <= c + dc < len(grid[0]) and grid[r + dr][c + dc] != "#"
    ]


def cheats(grid, p, num_cheats):
    r, c = p
    for dr in range(-num_cheats, num_cheats + 1):
        for dc in range(-num_cheats + abs(dr), num_cheats + 1 - abs(dr)):
            if 0 <= (nr:=r+dr) < len(grid) and 0 <= (nc:=c+dc) < len(grid[0]) and grid[nr][nc] != "#":
                yield ((nr, nc), abs(dr) + abs(dc))


def dijkstra(grid, start, end):
    q = [start]
    dist = {start: 0}
    while q:
        u = q.pop()
        for r, c in neighbors(grid, u):
            if (r, c) not in dist:
                q.append((r, c))
                dist[(r, c)] = dist[u] + 1
    return dist


def count_cheats(grid, num_cheats):
    start = next((r, c) for r in range(len(grid)) for c in range(len(grid[0])) if grid[r][c] == "S")
    end = next((r, c) for r in range(len(grid)) for c in range(len(grid[0])) if grid[r][c] == "E")
    dist = dijkstra(grid, start, end)
    c = 0
    for k, v in dist.items():
        for p, d in cheats(grid, k, num_cheats):
            if p in dist and dist[p] - d >= v + 100:
                c += 1
    return c


def main():
    with open("input.txt", "r") as f:
        grid = f.read().strip().splitlines()
    print("Part 1:", count_cheats(grid, 2))
    print("Part 2:", count_cheats(grid, 20))


if __name__ == "__main__":
    main()
