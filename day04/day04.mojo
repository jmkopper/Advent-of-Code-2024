@value
struct Point:
    var row: Int
    var col: Int

    fn __add__(self, other: Self) -> Self:
        return Point(self.row + other.row, self.col + other.col)


alias DIRS = List[Point](
    Point(0, 1),
    Point(0, -1),
    Point(1, 0),
    Point(-1, 0),
    Point(1, 1),
    Point(1, -1),
    Point(-1, 1),
    Point(-1, -1),
)


fn is_inbounds(grid: List[String], loc: Point) -> Int:
    if loc.row < 0 or loc.row >= len(grid):
        return 0
    if loc.col < 0 or loc.col >= len(grid[loc.row]):
        return 0
    return 1


fn is_xmas(grid: List[String], loc: Point, d: Point) -> Int:
    var x_coord = loc
    var m_coord = x_coord + d
    var a_coord = m_coord + d
    var s_coord = a_coord + d

    if not is_inbounds(grid, s_coord):
        return False

    return (
        grid[x_coord.row][x_coord.col] == "X"
        and grid[m_coord.row][m_coord.col] == "M"
        and grid[a_coord.row][a_coord.col] == "A"
        and grid[s_coord.row][s_coord.col] == "S"
    )


fn word_ok(a: String, b: String) -> Int:
    if (a == "M" and b == "S") or (a == "S" and b == "M"):
        return 1
    return 0


fn is_x_mas(grid: List[String], loc: Point) -> Int:
    if grid[loc.row][loc.col] != "A":
        return 0

    if (not is_inbounds(grid, loc + Point(1, 1))) or (
        not is_inbounds(grid, loc + Point(-1, -1))
    ):
        return 0

    var word1 = word_ok(
        grid[loc.row - 1][loc.col - 1], grid[loc.row + 1][loc.col + 1]
    )
    var word2 = word_ok(
        grid[loc.row - 1][loc.col + 1], grid[loc.row + 1][loc.col - 1]
    )

    return word1 * word2


fn part1(grid: List[String]) -> Int:
    var cnt = 0
    for row in range(len(grid)):
        for col in range(len(grid[row])):
            for d in DIRS:
                cnt += is_xmas(grid, Point(row, col), d[])
    return cnt


fn part2(grid: List[String]) -> Int:
    var cnt = 0
    for row in range(len(grid)):
        for col in range(len(grid[row])):
            cnt += is_x_mas(grid, Point(row, col))
    return cnt


fn main() raises:
    var text: List[String]
    with open("input.txt", "r") as f:
        text = f.read().strip().splitlines()

    var p1 = part1(text)
    var p2 = part2(text)

    print("Part 1: ", p1)
    print("Part 2: ", p2)
