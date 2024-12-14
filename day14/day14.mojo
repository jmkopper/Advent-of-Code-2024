alias NUM_ROWS = 103
alias NUM_COLS = 101


@value
struct Robot:
    var row: Int
    var col: Int
    var vr: Int
    var vc: Int


fn parse_row(line: String) raises -> Robot:
    var s = line.split(" ")
    var p = s[0].split("=")[1].split(",")
    var v = s[1].split("=")[1].split(",")
    return Robot(atol(p[1]), atol(p[0]), atol(v[1]), atol(v[0]))


fn safety_factor(robots: List[Robot]) -> Int:
    var q1 = 0
    var q2 = 0
    var q3 = 0
    var q4 = 0

    for robot in robots:
        if robot[].row < NUM_ROWS // 2 and robot[].col > NUM_COLS // 2:
            q1 += 1
        elif robot[].row < NUM_ROWS // 2 and robot[].col < NUM_COLS // 2:
            q2 += 1
        elif robot[].row > NUM_ROWS // 2 and robot[].col < NUM_COLS // 2:
            q3 += 1
        elif robot[].row > NUM_ROWS // 2 and robot[].col > NUM_COLS // 2:
            q4 += 1

    return q1 * q2 * q3 * q4


fn part1(robots: List[Robot], secs: Int = 100) -> Int:
    var new_robots = List[Robot]()
    for robot in robots:
        var new_r = (robot[].row + secs * robot[].vr) % NUM_ROWS
        var new_c = (robot[].col + secs * robot[].vc) % NUM_COLS
        new_robots.append(Robot(new_r, new_c, robot[].vr, robot[].vc))
    return safety_factor(new_robots)


fn print_robots(robots: List[Robot]):
    var grid = List[List[Int]]()
    for _ in range(NUM_ROWS):
        var row = List[Int]()
        for _ in range(NUM_COLS):
            row.append(0)
        grid.append(row)
    for robot in robots:
        var r = robot[].row
        var c = robot[].col
        grid[r][c] += 1

    for row in grid:
        for ch in row[]:
            if ch[] == 0:
                print(".", end="")
            else:
                print(ch[], end="")
        print()


fn variances(robots: List[Robot]) -> Tuple[Float64, Float64]:
    var sx = 0
    var sy = 0

    for robot in robots:
        sx += robot[].col
        sy += robot[].row

    var mx = sx / len(robots)
    var my = sy / len(robots)

    var vx = 0.0
    var vy = 0.0
    for robot in robots:
        vx += (Float64(robot[].col) - mx) ** 2
        vy += (Float64(robot[].row) - my) ** 2

    return vx / len(robots), vy / len(robots)


fn part2(robots: List[Robot]) -> Int:
    var new_robots = List[Robot]()
    var num_robots = len(robots)
    for robot in robots:
        new_robots.append(robot[])

    var vx_min = Float64.MAX
    var vy_min = Float64.MAX

    for i in range(NUM_COLS * NUM_ROWS):
        for j in range(num_robots):
            var new_r = (new_robots[j].row + new_robots[j].vr) % NUM_ROWS
            var new_c = (new_robots[j].col + new_robots[j].vc) % NUM_COLS
            new_robots[j] = Robot(
                new_r, new_c, new_robots[j].vr, new_robots[j].vc
            )

        var v = variances(new_robots)
        if v[0] < vx_min:
            vx_min = min(v[0], vx_min)

        if v[1] < vy_min:
            vy_min = min(v[1], vy_min)

        if v[0] == vx_min and v[1] == vy_min and i > NUM_ROWS:
            print_robots(new_robots)
            return i + 1
    return -1


fn main() raises:
    var text: List[String]
    with open("input.txt", "r") as f:
        text = f.read().strip().splitlines()

    var robots = List[Robot]()
    for line in text:
        robots.append(parse_row(line[]))

    print("Part 1:", part1(robots))
    print("Part 2:", part2(robots))
