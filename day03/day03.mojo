from collections import Optional


fn find_next_mul(text: String, offset: Int) -> Optional[Int]:
    var i = offset
    while i < len(text) - 3:
        if text[i : i + 4] == "mul(":
            return i
        i += 1
    return None


fn find_next_instruction(text: String, offset: Int) -> Optional[Int]:
    var i = offset
    while i < len(text) - 7:
        if (
            text[i : i + 4] == "mul("
            or text[i : i + 4] == "do()"
            or text[i : i + 7] == "don't()"
        ):
            return i
        i += 1
    return None


fn parse_mul(text: String, offset: Int) -> Optional[Int]:
    var comma_idx = offset + 4
    var left = 0
    var right = 0
    while comma_idx < len(text):
        var c = ord(text[comma_idx])
        if c >= 48 and c <= 57:
            left = left * 10 + (c - 48)
        elif c == 44:  # ord(',') is 44
            break
        else:
            return None
        comma_idx += 1

    if comma_idx == len(text) - 1:
        return None

    var rparen_idx = comma_idx + 1
    while rparen_idx < len(text):
        var c = ord(text[rparen_idx])
        if c >= 48 and c <= 57:
            right = right * 10 + (c - 48)
        elif c == 41:  # ord(')') is 41
            break
        else:
            return None
        rparen_idx += 1

    # early return if there's no rparen
    if text[rparen_idx] != ")":
        return None

    return left * right


fn part1(text: String) -> Int:
    var i = 0
    var total = 0
    while i < len(text):
        var offset = find_next_mul(text, i)
        if not offset:
            break
        var j = offset.value()
        total += parse_mul(text, j).or_else(0)
        i = j + 1
    return total


fn part2(text: String) -> Int:
    var i = 0
    var total = 0
    var do = True
    while i < len(text):
        var offset = find_next_instruction(text, i)
        if not offset:
            break

        var j = offset.value()
        var cmd = text[j : j + 4]
        if cmd == "mul(" and do:
            total += parse_mul(text, j).or_else(0)
        elif cmd == "do()":
            do = True
        elif text[j : j + 7] == "don't()":
            do = False

        i = j + 1
    return total


fn main() raises:
    var text: String
    with open("input.txt", "r") as f:
        text = f.read().strip()

    print("Part 1: ", part1(text))
    print("Part 2: ", part2(text))
