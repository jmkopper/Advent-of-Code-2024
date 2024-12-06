from collections import Set


@value
struct Position(KeyElement):
    var row: Int
    var col: Int
    var dir: Int  # 0=N, 1=E, 2=S, 3=W

    fn __eq__(self, other: Self) -> Bool:
        return (
            self.row == other.row
            and self.col == other.col
            and self.dir == other.dir
        )

    fn __hash__(self) -> UInt:
        return hash(self.row) ^ hash(self.col) ^ hash(self.dir)

    fn __ne__(self, other: Self) -> Bool:
        return (
            (self.row != other.row)
            or (self.col != other.col)
            or (self.dir != other.dir)
        )


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


trait CSize(CollectionElement, Sized):
    ...


fn is_inbounds[T: CSize](grid: List[T], pos: Position) -> Bool:
    return (pos.row >= 0 and pos.row < len(grid)) and (
        pos.col >= 0 and pos.col < len(grid[pos.row])
    )


fn next_pos(pos: Position) -> Position:
    var dr = 0
    var dc = 0
    if pos.dir == 0:
        dr = -1
    elif pos.dir == 1:
        dc = 1
    elif pos.dir == 2:
        dr = 1
    elif pos.dir == 3:
        dc = -1
    return Position(pos.row + dr, pos.col + dc, pos.dir)


fn is_loop(grid: List[List[String]], start: Position) -> Bool:
    var visited = Set[Position]()
    var pos = Position(start.row, start.col, start.dir)

    while is_inbounds(grid, pos):
        if pos in visited:
            return True
        visited.add(pos)
        var next_p = next_pos(pos)

        if not is_inbounds(grid, next_p):
            break

        var cur = Position(pos.row, pos.col, pos.dir)
        while grid[next_p.row][next_p.col] == "#":
            cur.dir = (cur.dir + 1) % 4
            next_p = next_pos(cur)
        pos = next_p
    return False


fn part2(grid: List[String]) raises -> Int:
    var cnt = 0
    var pos = Position(0, 0, 0)
    for i in range(len(grid)):
        for j in range(len(grid[i])):
            if grid[i][j] == "^":
                pos = Position(i, j, 0)
                break

    var cgrid = List[List[String]]()
    for i in range(len(grid)):
        var row = List[String]()
        for j in range(len(grid[i])):
            row.append(grid[i][j])
        cgrid.append(row)

    for i in range(len(grid)):
        for j in range(len(grid[i])):
            if grid[i][j] == "#" or grid[i][j] == "^":
                continue
            cgrid[i][j] = "#"
            if is_loop(cgrid, pos):
                cnt += 1
            cgrid[i][j] = "."

    return cnt


fn part1(grid: List[String]) -> Int:
    var pos = Position(0, 0, 0)
    var visited = Set[Point]()
    for i in range(len(grid)):
        for j in range(len(grid[i])):
            if grid[i][j] == "^":
                pos = Position(i, j, 0)
                break

    while is_inbounds(grid, pos):
        visited.add(Point(pos.row, pos.col))
        var next_p = next_pos(pos)

        if not is_inbounds(grid, next_p):
            break

        var cur = Position(pos.row, pos.col, pos.dir)
        while grid[next_p.row][next_p.col] == "#":
            cur.dir = (cur.dir + 1) % 4
            next_p = next_pos(cur)
        pos = next_p

    return len(visited)


fn main() raises:
    var grid: List[String]
    with open("input.txt", "r") as f:
        grid = f.read().strip().split("\n")

    print("Part 1: ", part1(grid))
    print("Part 2: ", part2(grid))
