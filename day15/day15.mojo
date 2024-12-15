from collections import Dict

alias EMPTY = 0
alias ROBOT = 1
alias BOX = 2
alias WALL = 3
alias BOX_LEFT = 4
alias BOX_RIGHT = 5


@value
struct Vec2D(KeyElement):
    var row: Int
    var col: Int

    fn __add__(self, other: Self) -> Self:
        return Vec2D(self.row + other.row, self.col + other.col)

    fn __eq__(self, other: Self) -> Bool:
        return self.row == other.row and self.col == other.col

    fn __ne__(self, other: Self) -> Bool:
        return self.row != other.row or self.col != other.col

    fn __hash__(self) -> UInt:
        return hash(self.row) ^ hash(self.col)


@value
struct Grid:
    var positions: List[List[Int]]
    var robot_position: Vec2D

    fn make_move(inout self, move: Vec2D):
        var pos_to_move = List[Vec2D]()
        var c = self.robot_position + move
        var next_obj = self.positions[c.row][c.col]
        while next_obj == BOX:
            pos_to_move.append(c)
            c = c + move
            next_obj = self.positions[c.row][c.col]
        if next_obj == WALL:
            return
        var new_robot_pos = self.robot_position + move
        self.positions[new_robot_pos.row][new_robot_pos.col] = ROBOT
        self.positions[self.robot_position.row][self.robot_position.col] = EMPTY
        self.robot_position = new_robot_pos
        for obj in pos_to_move:
            var new_p = obj[] + move
            self.positions[new_p.row][new_p.col] = BOX

    fn make_move2(inout self, move: Vec2D):
        var visited = Dict[Vec2D, Int]()
        var move_ok = self.move_dfs(move, self.robot_position, visited)
        if not move_ok:
            return

        for obj in visited.items():
            var k = obj[].key
            self.positions[k.row][k.col] = EMPTY

        for obj in visited.items():
            var k = obj[].key
            var v = obj[].value
            var n = k + move
            self.positions[n.row][n.col] = v
            if v == ROBOT:
                self.robot_position = n

    fn move_dfs(
        self, move: Vec2D, pos: Vec2D, inout visited: Dict[Vec2D, Int]
    ) -> Bool:
        if pos in visited:
            return True
        var symbol = self.positions[pos.row][pos.col]
        if symbol == EMPTY:
            return True
        if symbol == WALL:
            return False
        visited[pos] = symbol
        var n = pos + move
        var others = True
        if symbol == BOX_LEFT:
            others = self.move_dfs(move, pos + Vec2D(0, 1), visited)
        elif symbol == BOX_RIGHT:
            others = self.move_dfs(move, pos + Vec2D(0, -1), visited)
        return self.move_dfs(move, n, visited) and others

    fn gps_sum(self) -> Int:
        var s = 0
        for i in range(len(self.positions)):
            for j in range(len(self.positions[i])):
                if (
                    self.positions[i][j] == BOX
                    or self.positions[i][j] == BOX_LEFT
                ):
                    s += 100 * i + j
        return s


fn parse_grid(grid: String) -> Grid:
    var lines = grid.splitlines()
    var res = List[List[Int]](capacity=len(lines))
    var robot_position = Vec2D(-1, -1)
    for i in range(len(lines)):
        var row = List[Int](capacity=len(lines[i]))
        for j in range(len(lines[i])):
            var ch = lines[i][j]
            if ch == "#":
                row.append(WALL)
            elif ch == ".":
                row.append(EMPTY)
            elif ch == "@":
                robot_position = Vec2D(i, j)
                row.append(ROBOT)
            elif ch == "O":
                row.append(BOX)
        res.append(row)
    return Grid(res, robot_position)


fn parse_directions(directions: String) -> List[Vec2D]:
    var res = List[Vec2D]()
    for d in directions:
        if d == "^":
            res.append(Vec2D(-1, 0))
        elif d == ">":
            res.append(Vec2D(0, 1))
        elif d == "v":
            res.append(Vec2D(1, 0))
        elif d == "<":
            res.append(Vec2D(0, -1))
    return res


fn make_part2_grid(grid: Grid) -> Grid:
    var pos = List[List[Int]]()
    var robot_position = Vec2D(-1, -1)
    for i in range(len(grid.positions)):
        var row = List[Int]()
        for j in range(len(grid.positions[i])):
            var symbol = grid.positions[i][j]
            if symbol == ROBOT:
                row.append(ROBOT)
                row.append(EMPTY)
            elif symbol == BOX:
                row.append(BOX_LEFT)
                row.append(BOX_RIGHT)
            else:
                row.append(symbol)
                row.append(symbol)
        pos.append(row)

    for i in range(len(pos)):
        for j in range(len(pos[i])):
            if pos[i][j] == ROBOT:
                robot_position = Vec2D(i, j)
    return Grid(pos, robot_position)


fn part1(inout grid: Grid, directions: List[Vec2D]) -> Int:
    for dir in directions:
        grid.make_move(dir[])
    return grid.gps_sum()


fn part2(inout grid: Grid, directions: List[Vec2D]) -> Int:
    for dir in directions:
        grid.make_move2(dir[])
    return grid.gps_sum()


fn main() raises:
    var chunks = List[String]()
    with open("input.txt", "r") as f:
        chunks = f.read().strip().split("\n\n")

    var grid = parse_grid(chunks[0])
    var p2_grid = make_part2_grid(grid)
    var directions = parse_directions(chunks[1])
    print("Part 1:", part1(grid, directions))
    print("Part 2:", part2(p2_grid, directions))
