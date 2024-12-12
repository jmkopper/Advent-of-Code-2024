@value
struct Point:
    var row: Int
    var col: Int


fn is_inbounds(grid: List[String], row: Int, col: Int) -> Bool:
    return row >= 0 and row < len(grid) and col >= 0 and col < len(grid[0])


fn get_neighbors(grid: List[String], row: Int, col: Int) -> List[Point]:
    var c = grid[row][col]
    var neighbors = List[Point]()
    if is_inbounds(grid, row + 1, col) and grid[row + 1][col] == c:
        neighbors.append(Point(row + 1, col))

    if is_inbounds(grid, row - 1, col) and grid[row - 1][col] == c:
        neighbors.append(Point(row - 1, col))

    if is_inbounds(grid, row, col + 1) and grid[row][col + 1] == c:
        neighbors.append(Point(row, col + 1))

    if is_inbounds(grid, row, col - 1) and grid[row][col - 1] == c:
        neighbors.append(Point(row, col - 1))

    return neighbors


fn count_perim_area(
    grid: List[String], row: Int, col: Int, inout visited: List[List[Int]]
) -> Tuple[Int, Int]:
    var q = List[Point](Point(row, col))
    var perim = 0
    var area = 0

    while len(q) > 0:
        var u = q[0]
        q = q[1:]
        if visited[u.row][u.col] == 1:
            continue
        visited[u.row][u.col] = 1
        area += 1
        perim += 4

        for n in get_neighbors(grid, u.row, u.col):
            if visited[n[].row][n[].col] == 1:
                perim -= 2
            else:
                q.append(Point(n[].row, n[].col))

    return (perim, area)


fn fill_region(grid: List[String], row: Int, col: Int) -> List[List[Int]]:
    var region = List[List[Int]]()
    for _ in range(len(grid) + 2):  # pad to avoid bounds checking
        var row = List[Int]()
        for _ in range(len(grid[0]) + 2):  # ditto
            row.append(0)
        region.append(row)

    var q = List[Point](Point(row + 1, col + 1))
    while len(q) > 0:
        var u = q[0]
        q = q[1:]
        if region[u.row][u.col] == 1:
            continue
        region[u.row][u.col] = 1
        for n in get_neighbors(grid, u.row - 1, u.col - 1):
            q.append(Point(n[].row + 1, n[].col + 1))
    return region


fn count_corners(region: List[List[Int]]) -> Int:
    var nrows = len(region) - 1
    var ncols = len(region[0]) - 1
    var corners = 0

    for i in range(1, nrows):
        for j in range(1, ncols):
            if region[i][j] == 0:
                continue

            if region[i - 1][j] == 0:
                if region[i - 1][j + 1] == 1 or region[i][j + 1] == 0:
                    corners += 1

            if region[i + 1][j] == 0:
                if region[i + 1][j + 1] == 1 or region[i][j + 1] == 0:
                    corners += 1

            if region[i][j - 1] == 0:
                if region[i + 1][j] == 0 or region[i + 1][j - 1] == 1:
                    corners += 1

            if region[i][j + 1] == 0:
                if region[i + 1][j] == 0 or region[i + 1][j + 1] == 1:
                    corners += 1

    return corners


fn part1(grid: List[String]) -> Int:
    var nrows = len(grid)
    var ncols = len(grid[0])
    var visited = List[List[Int]]()
    for _ in range(nrows):
        var row = List[Int]()
        for _ in range(ncols):
            row.append(0)
        visited.append(row)

    var cost = 0
    for i in range(nrows):
        for j in range(ncols):
            if visited[i][j] == 1:
                continue
            var ap = count_perim_area(grid, i, j, visited)
            cost += ap[0] * ap[1]

    return cost


fn part2(grid: List[String]) -> Int:
    var nrows = len(grid)
    var ncols = len(grid[0])
    var visited = List[List[Int]]()
    for _ in range(nrows):
        var row = List[Int]()
        for _ in range(ncols):
            row.append(0)
        visited.append(row)

    var cost = 0
    for i in range(nrows):
        for j in range(ncols):
            if visited[i][j] == 1:
                continue
            var ap = count_perim_area(grid, i, j, visited)
            var region = fill_region(grid, i, j)
            var sides = count_corners(region)
            cost += sides * ap[1]
            for r in range(nrows):
                for c in range(ncols):
                    if region[r + 1][c + 1] == 1:
                        visited[r][c] = 1
    return cost


fn main() raises:
    var grid: List[String]
    with open("input.txt", "r") as f:
        grid = f.read().strip().splitlines()
    print("Part 1:", part1(grid))
    print("Part 2:", part2(grid))
