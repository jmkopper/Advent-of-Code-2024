from collections import Dict, Set


@value
struct Point(KeyElement):
    var row: Int
    var col: Int

    fn __eq__(self, other: Self) -> Bool:
        return self.row == other.row and self.col == other.col

    fn __hash__(self) -> UInt:
        return hash(self.row) ^ hash(self.col)

    fn __ne__(self, other: Self) -> Bool:
        return (self.row != other.row) or (self.col != other.col)

    @always_inline
    fn inbounds(self, nrows: Int, ncols: Int) -> Bool:
        return (
            self.row >= 0
            and self.row < nrows
            and self.col >= 0
            and self.col < ncols
        )


fn antinode_pairs(a: Point, b: Point) -> List[Point]:
    var antinodes = List[Point]()
    if a.row == b.row and a.col == b.col:
        return antinodes
    var dr = b.row - a.row
    var dc = b.col - a.col

    antinodes.append(Point(b.row + dr, b.col + dc))
    antinodes.append(Point(a.row - dr, a.col - dc))
    return antinodes


fn find_antinodes(antennas: List[Point]) -> List[Point]:
    var antinodes = List[Point]()
    for i in range(len(antennas)):
        for j in range(i, len(antennas)):
            antinodes.extend(antinode_pairs(antennas[i], antennas[j]))
    return antinodes


fn all_inline(a: Point, b: Point, nrows: Int, ncols: Int) -> List[Point]:
    var antinodes = List[Point]()
    if a.row == b.row and a.col == b.col:
        return antinodes
    var dr = b.row - a.row
    var dc = b.col - a.col
    var cur = b
    while cur.inbounds(nrows, ncols):
        antinodes.append(cur)
        cur.row += dr
        cur.col += dc
    cur = a
    while cur.inbounds(nrows, ncols):
        antinodes.append(cur)
        cur.row -= dr
        cur.col -= dc
    return antinodes


fn find_antinodes2(
    antennas: List[Point], nrows: Int, ncols: Int
) -> List[Point]:
    var antinodes = List[Point]()
    for i in range(len(antennas)):
        for j in range(i, len(antennas)):
            antinodes.extend(all_inline(antennas[i], antennas[j], nrows, ncols))
    return antinodes


fn part1(
    antennas: Dict[String, List[Point]], nrows: Int, ncols: Int
) raises -> Int:
    var antinodes = Set[Point]()
    for k in antennas.items():
        for antinode in find_antinodes(k[].value):
            if antinode[].inbounds(nrows, ncols):
                antinodes.add(antinode[])
    return len(antinodes)


fn part2(
    antennas: Dict[String, List[Point]], nrows: Int, ncols: Int
) raises -> Int:
    var antinodes = Set[Point]()
    for k in antennas.items():
        for antinode in find_antinodes2(k[].value, nrows, ncols):
            antinodes.add(antinode[])
    return len(antinodes)


fn main() raises:
    var grid: List[String]
    with open("input.txt", "r") as f:
        grid = f.read().strip().split("\n")

    var antennas = Dict[String, List[Point]]()
    for i in range(len(grid)):
        for j in range(len(grid[i])):
            var c = grid[i][j]
            if grid[i][j] != ".":
                if c in antennas:
                    antennas[c].append(Point(i, j))
                else:
                    antennas[c] = List(Point(i, j))

    var nrows = len(grid)
    var ncols = len(grid[0])

    print("Part 1: ", part1(antennas, nrows, ncols))
    print("Part 2: ", part2(antennas, nrows, ncols))
