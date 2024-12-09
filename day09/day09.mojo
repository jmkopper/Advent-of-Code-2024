fn part1(disk_map: List[Int]) -> Int:
    var files = List[Int]()
    var free_space = List[Int]()
    var total_len = 0
    for i in range(0, len(disk_map), 2):
        files.append(disk_map[i])
        total_len += disk_map[i]

    for i in range(1, len(disk_map), 2):
        free_space.append(disk_map[i])
        total_len += disk_map[i]

    var file_id = 0
    var file_id_end = len(files) - 1
    var free_id = 0
    var compacted = List[Int](capacity=total_len)

    while file_id <= file_id_end:
        for _ in range(files[file_id]):
            compacted.append(file_id)
        files[file_id] = 0
        file_id += 1

        # fill free space
        while free_space[free_id] > 0 and file_id_end >= 0:
            while files[file_id_end] > 0 and free_space[free_id] > 0:
                compacted.append(file_id_end)
                files[file_id_end] -= 1
                free_space[free_id] -= 1
            if files[file_id_end] == 0:
                file_id_end -= 1
        if free_space[free_id] == 0:
            free_id += 1

    var checksum = 0
    for i in range(len(compacted)):
        checksum += i * compacted[i]
    return checksum


fn part2(disk_map: List[Int]) -> Int:
    var id_cnts = List[Int]()
    var id_starts = List[Int]()
    var free_space = List[Int]()
    var free_space_used = List[Int]()
    var free_space_starts = List[Int]()
    var total_len = 0

    for i in range(0, len(disk_map)):
        if i % 2 == 0:
            id_cnts.append(disk_map[i])
            id_starts.append(total_len)
            total_len += disk_map[i]
        else:
            free_space.append(disk_map[i])
            free_space_used.append(0)
            free_space_starts.append(total_len)
            total_len += disk_map[i]

    var compacted = List[Int](capacity=total_len)
    for i in range(len(disk_map)):
        var idx = i // 2
        if i % 2 == 0:
            for _ in range(id_cnts[idx]):
                compacted.append(idx)
        else:
            for _ in range(free_space[idx]):
                compacted.append(0)

    var file_id = len(id_cnts) - 1
    while file_id >= 0:
        for free_id in range(len(free_space)):
            if id_starts[file_id] < free_space_starts[free_id]:
                break

            var diff = free_space[free_id] - free_space_used[free_id] - id_cnts[
                file_id
            ]
            if diff >= 0:
                var free_offset = free_space_starts[free_id] + free_space_used[
                    free_id
                ]

                # move the file left
                for j in range(id_cnts[file_id]):
                    compacted[free_offset + j] = file_id
                    compacted[id_starts[file_id] + j] = 0
                free_space_used[free_id] += id_cnts[file_id]
                break

        file_id -= 1

    var checksum = 0
    for i in range(len(compacted)):
        checksum += i * compacted[i]
    return checksum


fn main() raises:
    var text: String
    with open("input.txt", "r") as f:
        text = f.read().strip()
    var disk_map = List[Int]()
    for c in text:
        disk_map.append(atol(c))

    print("Part 1: ", part1(disk_map))
    print("Part 2: ", part2(disk_map))
