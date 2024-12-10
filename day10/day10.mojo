@always_inline
fn check_neighbor(row: Int, col: Int, tmap: List[List[Int]], val: Int) -> Bool:
    if row < 0 or col < 0:
        return False
    if row >= len(tmap) or col >= len(tmap[row]):
        return False
    return tmap[row][col] == val + 1


fn compute_score_from(
    row: Int, col: Int, tmap: List[List[Int]], inout scores: List[List[Int]]
) -> Int:
    if scores[row][col] != -1:
        return scores[row][col]

    if tmap[row][col] == 9:
        scores[row][col] = 1
        return 1

    var c = 0
    var val = tmap[row][col]
    if check_neighbor(row - 1, col, tmap, val):
        c += compute_score_from(row - 1, col, tmap, scores)
    if check_neighbor(row + 1, col, tmap, val):
        c += compute_score_from(row + 1, col, tmap, scores)
    if check_neighbor(row, col - 1, tmap, val):
        c += compute_score_from(row, col - 1, tmap, scores)
    if check_neighbor(row, col + 1, tmap, val):
        c += compute_score_from(row, col + 1, tmap, scores)
    scores[row][col] = c
    return c


fn compute_scores(tmap: List[List[Int]]) -> List[List[Int]]:
    var scores = List[List[Int]]()
    for r in range(len(tmap)):
        var row = List[Int](capacity=len(tmap[r]))
        for _ in range(len(tmap[r])):
            row.append(-1)
        scores.append(row)

    for r in range(len(tmap)):
        for c in range(len(tmap[r])):
            _ = compute_score_from(r, c, tmap, scores)
    return scores


fn search_dfs(
    row: Int, col: Int, tmap: List[List[Int]], inout visited: List[List[Int]]
):
    if visited[row][col] == 1:
        return
    visited[row][col] = 1
    var val = tmap[row][col]
    if check_neighbor(row - 1, col, tmap, val):
        search_dfs(row - 1, col, tmap, visited)
    if check_neighbor(row + 1, col, tmap, val):
        search_dfs(row + 1, col, tmap, visited)
    if check_neighbor(row, col - 1, tmap, val):
        search_dfs(row, col - 1, tmap, visited)
    if check_neighbor(row, col + 1, tmap, val):
        search_dfs(row, col + 1, tmap, visited)


fn search_from(row: Int, col: Int, tmap: List[List[Int]]) -> Int:
    var visited = List[List[Int]]()
    for r in range(len(tmap)):
        var row = List[Int](capacity=len(tmap[r]))
        for _ in range(len(tmap[r])):
            row.append(0)
        visited.append(row)
    search_dfs(row, col, tmap, visited)

    var total = 0
    for r in range(len(tmap)):
        for c in range(len(tmap[r])):
            if visited[r][c] == 1 and tmap[r][c] == 9:
                total += 1
    return total


fn part1(tmap: List[List[Int]]) -> Int:
    var total = 0
    for r in range(len(tmap)):
        for c in range(len(tmap[r])):
            if tmap[r][c] == 0:
                total += search_from(r, c, tmap)
    return total


fn part2(tmap: List[List[Int]]) -> Int:
    var total = 0
    var scores = compute_scores(tmap)
    for r in range(len(tmap)):
        for c in range(len(tmap[r])):
            if tmap[r][c] == 0:
                total += scores[r][c]
    return total


fn main() raises:
    var text: List[String]
    with open("input.txt", "r") as f:
        text = f.read().strip().splitlines()
    var tmap = List[List[Int]]()
    for line in text:
        var r = List[Int]()
        for c in line[]:
            r.append(atol(c))
        tmap.append(r)

    print("Part 1: ", part1(tmap))
    print("Part 2: ", part2(tmap))
