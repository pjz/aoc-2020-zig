const std = @import("std");
const Allocator = std.mem.Allocator;
const assert = std.debug.assert;
const print = std.debug.print;

const input = @embedFile("../in08.txt");

const ExecutedArray = std.PackedIntArray(u1, 2048);

var line: [2048]usize = undefined;
var line_len: usize = 0;

fn load() void {
    line[0] = 0;
    var ln: u16 = 1;
    for (input) |c, i| {
        if (c == '\n') {
            line[ln] = i + 1;
            ln += 1;
        }
    }
    line_len = ln - 1;
}

pub fn main() !void {
    load();
    print("Loaded {} lines.\n", .{line_len});
    var i: usize = 0;
    var prev_acc: isize = undefined;
    while (i < line_len) {
        var acc = acc_chg_jmp(i);
        //if (acc == prev_acc) break;
        prev_acc = acc;
        i += 1;
    }
}

pub fn acc_chg_jmp(ichange: usize) isize {
    var executed = ExecutedArray.init(std.mem.zeroes([2048]u1));

    var acc: isize = 0;
    var ic: usize = 0;
    var nopjmp: usize = 0;

    print("Changing jmpnop {}: ", .{ichange});
    while (executed.get(ic) == 0) {
        executed.set(ic, 1);
        //print("Executing line {}: ", .{ic});
        var eol: usize = line.len;
        if (ic < line_len) {
            eol = line[ic + 1] - 1;
        }
        var instr = input[line[ic]..eol];
        var num = std.mem.trimLeft(u8, instr[4..], " \n");
        var arg = std.fmt.parseInt(i16, num, 10) catch |err| {
            print("problem parsing {}.", .{num});
            @panic("problem parsing number");
        };
        if (std.mem.startsWith(u8, instr, "jmp")) {
            nopjmp += 1;
            if (nopjmp == ichange) {
                ic += 1; // nop
            } else {
                ic = @intCast(usize, @intCast(isize, ic) + arg);
            }
        } else if (std.mem.startsWith(u8, instr, "acc")) {
            acc += arg;
            ic += 1;
        } else if (std.mem.startsWith(u8, instr, "nop")) {
            nopjmp += 1;
            if (nopjmp == ichange) {
                ic = @intCast(usize, @intCast(isize, ic) + arg);
            } else {
                ic += 1;
            }
        } else {
            print("incomprehensible instruction {}", .{instr});
            @panic(":(");
        }
        // print("{} ({}) -> {} :", .{ instr, num, ic });
        if (ic >= line_len) {
            print(" No infinite loop! ", .{});
            break;
        }
    }
    print("acc is {}.\n", .{acc});
    return acc;
}
