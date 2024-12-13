from collections import Optional


@value
struct Game:
    var ax: Int
    var ay: Int
    var bx: Int
    var by: Int
    var targetx: Int
    var targety: Int


@value
struct Solution:
    var x: Int
    var y: Int


fn parse_row(s: String, c: String) raises -> Tuple[Int, Int]:
    var q = s.strip().split(": ")
    var w = q[1].strip().split(", ")
    var x_str = w[0].split(c)[1]
    var y_str = w[1].split(c)[1]
    return atol(x_str), atol(y_str)


fn parse_game(s: String) raises -> Game:
    var lines = s.strip().splitlines()
    var a = parse_row(lines[0], "+")
    var b = parse_row(lines[1], "+")
    var t = parse_row(lines[2], "=")
    return Game(a[0], a[1], b[0], b[1], t[0], t[1])


fn solve(game: Game) -> Optional[Solution]:
    var det = game.ax * game.by - game.ay * game.bx
    if det == 0:
        return None

    var prod1 = game.targetx * game.by
    var prod2 = -game.targety * game.bx
    var prod3 = -game.targetx * game.ay
    var prod4 = game.targety * game.ax
    if (prod1 + prod2) % det != 0 or (prod3 + prod4) % det != 0:
        return None

    return Solution((prod1 + prod2) // det, (prod3 + prod4) // det)


fn part1(games: List[Game]) -> Int:
    var res = 0
    for g in games:
        var s = solve(g[])
        if s:
            res += 3 * s.value().x + s.value().y

    return res


fn part2(games: List[Game]) -> Int:
    var res = 0
    for g in games:
        var new_g = Game(
            g[].ax,
            g[].ay,
            g[].bx,
            g[].by,
            g[].targetx + 10000000000000,
            g[].targety + 10000000000000,
        )
        var s = solve(new_g)
        if s:
            res += 3 * s.value().x + s.value().y

    return res


fn main() raises:
    var text: List[String]
    with open("input.txt", "r") as f:
        text = f.read().strip().split("\n\n")
    var games = List[Game]()
    for chunk in text:
        games.append(parse_game(chunk[]))

    print("Part 1:", part1(games))
    print("Part 2:", part2(games))
