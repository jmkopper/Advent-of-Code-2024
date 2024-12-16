from collections import Dict, Set


alias NORTH = 0
alias EAST = 1
alias SOUTH = 2
alias WEST = 3


@value
struct Point(Hashable):
    var row: Int
    var col: Int
    var dir: Int

    fn __hash__(self) -> UInt:
        return hash(self.row) ^ hash(self.col) ^ hash(self.dir)

    fn __eq__(self, other: Self) -> Bool:
        return (
            self.row == other.row
            and self.col == other.col
            and self.dir == other.dir
        )

    fn __ne__(self, other: Self) -> Bool:
        return (
            self.row != other.row
            or self.col != other.col
            or self.dir != other.dir
        )

    fn no_dir(self) -> PointNoDir:
        return PointNoDir(self.row, self.col)


@value
struct PointNoDir(Hashable):
    var row: Int
    var col: Int

    fn __hash__(self) -> UInt:
        return hash(self.row) ^ hash(self.col)

    fn __eq__(self, other: Self) -> Bool:
        return self.row == other.row and self.col == other.col

    fn __ne__(self, other: Self) -> Bool:
        return self.row != other.row or self.col != other.col


@value
struct PointWithPath:
    var point: Point
    var path: List[PointNoDir]
    var score: Int


fn find_s_e(grid: List[String]) -> Tuple[Point, Point]:
    var s = (-1, -1)
    var e = (-1, -1)
    for i in range(len(grid)):
        for j in range(len(grid[i])):
            if grid[i][j] == "S":
                s = (i, j)
            if grid[i][j] == "E":
                e = (i, j)
    return Point(s[0], s[1], 1), Point(e[0], e[1], 0)


fn neighbors(grid: List[String], node: Point) -> List[Point]:
    var n = List[Point](capacity=4)
    if grid[node.row - 1][node.col] != "#":
        n.append(Point(node.row - 1, node.col, NORTH))
    if grid[node.row][node.col + 1] != "#":
        n.append(Point(node.row, node.col + 1, EAST))
    if grid[node.row + 1][node.col] != "#":
        n.append(Point(node.row + 1, node.col, SOUTH))
    if grid[node.row][node.col - 1] != "#":
        n.append(Point(node.row, node.col - 1, WEST))
    return n


fn dijkstra(grid: List[String], start: Point, end: Point) -> Tuple[Int, Int]:
    var dist = Dict[Point, Int]()
    var q = List(PointWithPath(start, List[PointNoDir](start.no_dir()), 0))
    var visited = Set[PointNoDir]()
    visited.add(start.no_dir())
    visited.add(end.no_dir())
    var best = Int.MAX

    while len(q) > 0:
        var next_idx = 0
        var next_dist = Int.MAX
        for i in range(len(q)):
            var d = dist.get(q[i].point).or_else(Int.MAX)
            if d < next_dist:
                next_idx = i
                next_dist = d
        var next_obj = q.pop(next_idx)
        var u = next_obj.point

        if u.no_dir() == end.no_dir():
            best = min(best, next_obj.score)
            if best == next_obj.score:
                for n in next_obj.path:
                    visited.add(n[])

        for n in neighbors(grid, u):
            var alt = next_obj.score + 1
            if u.dir != n[].dir:
                alt += 1000
            if alt <= dist.get(n[]).or_else(Int.MAX):
                dist[n[]] = alt
                var new_path = next_obj.path
                new_path.append(n[].no_dir())
                q.append(PointWithPath(n[], new_path, alt))

    return best, len(visited)


fn main() raises:
    var grid = List[String]()
    with open("input.txt", "r") as f:
        grid = f.read().strip().splitlines()

    var pts = find_s_e(grid)
    var start = pts[0]
    var end = pts[1]
    var res = dijkstra(grid, start, end)

    print("Part 1:", res[0])
    print("Part 2:", res[1])
