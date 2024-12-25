def run_system(gates, wires):
    z_values = [x for x in set(g[3] for g in gates) if x.startswith("z")]
    while not all(z in wires for z in z_values):
        for g in gates:
            if g[0] not in wires or g[2] not in wires:
                continue
            if g[1] == "AND":
                wires[g[3]] = wires[g[0]] and wires[g[2]]
            elif g[1] == "OR":
                wires[g[3]] = wires[g[0]] or wires[g[2]]
            else:
                wires[g[3]] = wires[g[0]] ^ wires[g[2]]
    res = 0
    for i, z in enumerate(sorted(z_values)):
        res = res | (wires[z] << i)
    return res


def part1(gates, wires):
    return run_system(gates, wires)


def part2(gates):
    z_values = sorted([x for x in set(g[3] for g in gates) if x.startswith("z")])
    max_zval = z_values[-1]
    swaps = []
    for g in gates:
        if g[3].startswith("z"):
            # output bits must come from XOR
            if g[1] != "XOR" and g[3] != max_zval:
                swaps.append(g[3])
        elif g[1] == "XOR":
            if g[0][0] not in {"x", "y"} or g[2][0] not in {"x", "y"}:
                # XORs that don't output z cannot have x/y input
                swaps.append(g[3])
            else:
                # XOR with x/y input must output to another XOR
                if not any(g2[1] == "XOR" and g[3] in {g2[0], g2[2]} for g2 in gates):
                    swaps.append(g[3])
        elif g[1] == "AND" and g[0] not in {"x00", "y00"}:
            # AND gates must have an OR input
            if not any(g2[1] == "OR" and g[3] in {g2[0], g2[2]} for g2 in gates):
                swaps.append(g[3])
    return ",".join(sorted(swaps))


def main():
    with open("input.txt", "r") as f:
        chunks = f.read().strip().split("\n\n")
        wire_lines = chunks[0].splitlines()
        gate_lines = chunks[1].splitlines()

    wires = {}
    for w in wire_lines:
        s = w.split(": ")
        wires[s[0]] = 1 if s[1] == "1" else 0

    gates = []
    for g in gate_lines:
        s = g.split(" ")
        gates.append((s[0], s[1], s[2], s[4]))

    print(f"Part 1: {part1(gates, wires)}")
    print(f"Part 2: {part2(gates)}")


main()
