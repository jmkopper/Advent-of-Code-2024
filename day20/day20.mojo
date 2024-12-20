from collections import Dict


@value
struct Vec2d(Hashable):
    var row: Int
    var col: Int

    fn __hash__(self) -> UInt:
        return hash(self.row) ^ hash(self.col)

    fn __eq__(self, other: Self) -> Bool:
        return self.row == other.row and self.col == other.col

    fn __ne__(self, other: Self) -> Bool:
        return self.row != other.row or self.col != other.col

    fn __add__(self, other: Self) -> Self:
        return Self(self.row + other.row, self.col + other.col)


fn find_s_e(grid: List[String]) -> Tuple[Vec2d, Vec2d]:
    var s = (-1, -1)
    var e = (-1, -1)
    for i in range(len(grid)):
        for j in range(len(grid[i])):
            if grid[i][j] == "S":
                s = (i, j)
            if grid[i][j] == "E":
                e = (i, j)
    return Vec2d(s[0], s[1]), Vec2d(e[0], e[1])


fn neighbors(grid: List[String], node: Vec2d) -> List[Vec2d]:
    var n = List[Vec2d](capacity=4)
    if grid[node.row - 1][node.col] != "#":
        n.append(Vec2d(node.row - 1, node.col))
    if grid[node.row][node.col + 1] != "#":
        n.append(Vec2d(node.row, node.col + 1))
    if grid[node.row + 1][node.col] != "#":
        n.append(Vec2d(node.row + 1, node.col))
    if grid[node.row][node.col - 1] != "#":
        n.append(Vec2d(node.row, node.col - 1))
    return n


@always_inline
fn inbounds(grid: List[String], point: Vec2d) -> Bool:
    return 0 <= point.row < len(grid) and 0 <= point.col < len(grid[0])


fn cheats(grid: List[String], start: Vec2d, num_steps: Int) -> Dict[Vec2d, Int]:
    var res = Dict[Vec2d, Int]()
    for dr in range(-num_steps, num_steps + 1):
        for dc in range(-num_steps + abs(dr), num_steps + 1 - abs(dr)):
            var t = start + Vec2d(dr, dc)
            if inbounds(grid, t) and grid[t.row][t.col] != "#":
                res[t] = abs(dr) + abs(dc)
    return res


fn dijkstra(
    grid: List[String], start: Vec2d, end: Vec2d
) raises -> Dict[Vec2d, Int]:
    var q = List[Vec2d](start)
    var dist = Dict[Vec2d, Int]()
    dist[start] = 0
    var level = 1
    while len(q) > 0:
        var level_size = len(q)
        while level_size > 0:
            var u = q.pop()
            level_size -= 1
            for n in neighbors(grid, u):
                if n[] in dist:
                    continue
                q.append(n[])
                dist[n[]] = level
        level += 1
    return dist


fn count_cheats(grid: List[String], cheat_time: Int) raises -> Int:
    var pts = find_s_e(grid)
    var start = pts[0]
    var end = pts[1]
    var dist = dijkstra(grid, start, end)
    var ct = 0
    for q in dist.items():
        k = q[].key
        v = q[].value
        var csquares = cheats(grid, k, cheat_time)
        for c in csquares.items():
            var p = c[].key
            var d = c[].value
            if p in dist and dist[p] - d >= v + 100:
                ct += 1
    return ct


fn main() raises:
    var grid = List[String]()
    with open("input.txt", "r") as f:
        grid = f.read().strip().splitlines()

    print("Part 1:", count_cheats(grid, 2))
    print("Part 2:", count_cheats(grid, 20))
