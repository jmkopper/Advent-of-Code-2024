from collections import Dict


@value
struct StoneKey(KeyElement):
    var value: Int
    var depth: Int

    fn __hash__(self) -> UInt:
        return hash(self.value) ^ hash(self.depth)

    fn __eq__(self, other: Self) -> Bool:
        return self.value == other.value and self.depth == other.depth

    fn __ne__(self, other: Self) -> Bool:
        return (self.value != other.value) or (self.depth != other.depth)


fn num_digits(a: Int) -> Int:
    var c = 10
    var n = 1
    while c <= a:
        n += 1
        c *= 10
    return n


fn separate_digits(a: Int) -> Tuple[Int, Int]:
    var ndigits = num_digits(a)
    var pow = 10 ** (ndigits // 2)
    var second = a % pow
    var first = (a - second) // pow
    return (first, second)


fn count_stones_memo(
    stone: Int, depth: Int, inout memo: Dict[StoneKey, Int]
) -> Int:
    if depth == 0:
        return 1

    var k = StoneKey(stone, depth)
    if k in memo:
        return memo.get(k).or_else(-1)

    var res: Int
    if stone == 0:
        res = count_stones_memo(1, depth - 1, memo)
    elif num_digits(stone) % 2 == 0:
        var new_stones = separate_digits(stone)
        res = count_stones_memo(
            new_stones[0], depth - 1, memo
        ) + count_stones_memo(new_stones[1], depth - 1, memo)
    else:
        res = count_stones_memo(stone * 2024, depth - 1, memo)

    memo[k] = res
    return res


fn count_stones(stones: List[Int], num_blinks: Int) -> Int:
    var count = 0
    var memo = Dict[StoneKey, Int]()
    for stone in stones:
        count += count_stones_memo(stone[], num_blinks, memo)

    return count


fn main() raises:
    var text: List[String]
    with open("input.txt", "r") as f:
        text = f.read().strip().split()
    var stones = List[Int]()
    for c in text:
        stones.append(atol(c[]))

    print("Part 1:", count_stones(stones, 25))
    print("Part 2:", count_stones(stones, 75))
