from collections import Set

alias Grid2d = List[List[Int]]
alias GRIDSIZE = 70
alias NUMBYTES = 1024
alias DIRS = List(Vec2d(0, 1), Vec2d(0, -1), Vec2d(1, 0), Vec2d(-1, 0))


@value
struct Vec2d(Hashable):
    var x: Int
    var y: Int

    fn __eq__(self, other: Self) -> Bool:
        return self.x == other.x and self.y == other.y

    fn __ne__(self, other: Self) -> Bool:
        return self.x != other.x or self.y != other.y

    fn __hash__(self) -> UInt:
        return hash(self.x) ^ hash(self.y)

    fn __add__(self, other: Self) -> Self:
        return Self(self.x + other.x, self.y + other.y)


fn make_grid(grid_size: Int) -> Grid2d:
    var grid = Grid2d(capacity=grid_size)
    for _ in range(grid_size):
        var row = List[Int](capacity=grid_size)
        for _ in range(grid_size):
            row.append(0)
        grid.append(row)
    return grid


fn parse_input(lines: List[String]) raises -> List[Vec2d]:
    var coords = List[Vec2d]()
    for line in lines:
        var s = line[].split(",")
        coords.append(Vec2d(atol(s[0]), atol(s[1])))
    return coords


fn inbounds(n: Vec2d, grid_size: Int = GRIDSIZE) -> Bool:
    return 0 <= n.x <= GRIDSIZE and 0 <= n.y <= GRIDSIZE


fn part1(
    falling_bytes: List[Vec2d],
    grid_size: Int = GRIDSIZE,
    num_bytes: Int = NUMBYTES,
) raises -> Int:
    var visited = Set[Vec2d]()
    var q = List[Vec2d](Vec2d(0, 0))
    var walls = Set[Vec2d]()
    var end = Vec2d(grid_size, grid_size)

    for b in falling_bytes[:num_bytes]:
        walls.add(Vec2d(b[].x, b[].y))

    var level = 0
    while len(q) > 0:
        var level_size = len(q)
        while level_size > 0:
            var u = q.pop(0)
            level_size -= 1
            if u == end:
                return level
            for dir in DIRS:
                var n = u + dir[]
                if (
                    (n in walls)
                    or (n in visited)
                    or (not inbounds(n, grid_size))
                ):
                    continue
                q.append(n)
                visited.add(n)
        level += 1

    return -1


fn part2(
    falling_bytes: List[Vec2d], grid_size: Int = GRIDSIZE
) raises -> String:
    for i in range(1024, len(falling_bytes)):
        if part1(falling_bytes, grid_size, i) == -1:
            return (
                str(falling_bytes[i - 1].x) + "," + str(falling_bytes[i - 1].y)
            )
    return ""


fn main() raises:
    var lines: List[String]
    with open("input.txt", "r") as f:
        lines = f.read().strip().splitlines()
    var coords = parse_input(lines)
    print("Part 1:", part1(coords))
    print("Part 2:", part2(coords))
