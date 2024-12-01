const std = @import("std");
const ArrayList = std.ArrayList;

fn parse_line(line: []const u8) !struct { u64, u64 } {
    var lval: u64 = 0;
    var rval: u64 = 0;
    var i: usize = 0;

    while (i < line.len and line[i] != ' ') : (i += 1) {
        const cur = line[i] - '0';
        lval *= 10;
        lval += @intCast(cur);
    }

    while (line[i] == ' ') : (i += 1) {}

    while (i < line.len and line[i] != '\n') : (i += 1) {
        const cur = line[i] - '0';
        rval *= 10;
        rval += @intCast(cur);
    }

    return .{ lval, rval };
}

fn part1(input: []const u8) !u64 {
    var lines = std.mem.split(u8, input, "\n");

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var left_list = ArrayList(u64).init(allocator);
    defer left_list.deinit();
    var right_list = ArrayList(u64).init(allocator);
    defer right_list.deinit();

    while (lines.next()) |line| {
        const cur = try parse_line(line);
        const left = cur[0];
        const right = cur[1];

        try left_list.append(left);
        try right_list.append(right);
    }

    const left_slice = try left_list.toOwnedSlice();
    const right_slice = try right_list.toOwnedSlice();

    std.mem.sort(u64, left_slice, {}, comptime std.sort.asc(u64));
    std.mem.sort(u64, right_slice, {}, comptime std.sort.asc(u64));

    var i: usize = 0;
    var sum: u64 = 0;
    while (i < left_slice.len) : (i += 1) {
        if (left_slice[i] <= right_slice[i]) {
            sum += right_slice[i] - left_slice[i];
        } else {
            sum += left_slice[i] - right_slice[i];
        }
    }

    return sum;
}

fn part2(input: []const u8) !u64 {
    var lines = std.mem.split(u8, input, "\n");

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var left_list = ArrayList(u64).init(allocator);
    defer left_list.deinit();
    var right_list = ArrayList(u64).init(allocator);
    defer right_list.deinit();

    while (lines.next()) |line| {
        const cur = try parse_line(line);
        const left = cur[0];
        const right = cur[1];

        try left_list.append(left);
        try right_list.append(right);
    }

    var h = std.AutoArrayHashMap(u64, u64).init(allocator);
    defer h.deinit();
    for (left_list.items) |lval| {
        try h.put(lval, 0);
    }

    for (right_list.items) |rval| {
        if (h.contains(rval)) {
            const c = h.get(rval).?;
            try h.put(rval, c + 1);
        }
    }

    var score: u64 = 0;

    for (h.keys()) |k| {
        score += k * h.get(k).?;
    }

    return score;
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    const p1 = try part1(input);
    const p2 = try part2(input);
    std.debug.print("Part 1: {d}\n", .{p1});
    std.debug.print("Part 2: {d}\n", .{p2});
}
