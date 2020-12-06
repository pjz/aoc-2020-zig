const std = @import("std");
const Allocator = std.mem.Allocator;
const assert = std.debug.assert;
const print = std.debug.print;

const input = @embedFile("../in06.txt");

pub fn contains(haystack: []const u8, needle: u8) bool {
    for (haystack) |c| {
        if (c == needle) return true;
    }
    return false;
}

const questions = "abcdefghijklmnopqrstuvwxyz";

pub fn answered_count(answers: []const u8) u8 {
    var count: u8 = 0;

    for (questions) |c| {
        if (contains(answers, c)) count += 1;
    }

    return count;
}

pub fn all_lines_contain(haystack: []const u8, needle: u8) bool {
    var line_it = std.mem.tokenize(haystack, "\n");
    while (line_it.next()) |line| {
        if (!contains(line, needle)) return false;
    }
    return true;
}

pub fn all_answered_count(answers: []const u8) u8 {
    var count: u8 = 0;

    for (questions) |c| {
        if (all_lines_contain(answers, c)) count += 1;
    }
    return count;
}

pub fn main() !void {
    var group_it = std.mem.split(input, "\n\n");
    var sum: usize = 0;
    while (group_it.next()) |answers| {
        sum += answered_count(answers);
    }
    print("part 1 sum is {}\n", .{sum});

    sum = 0;
    group_it = std.mem.split(input, "\n\n");
    while (group_it.next()) |answers| {
        sum += all_answered_count(answers);
    }
    print("part 2 sum is {}\n", .{sum});
}
