const std = @import("std");
const Allocator = std.mem.Allocator;
const assert = std.debug.assert;
const print = std.debug.print;

const input = @embedFile("../in04.txt");

const Passport = struct {
    byr: ?[]const u8 = null,
    iyr: ?[]const u8 = null,
    eyr: ?[]const u8 = null,
    hgt: ?[]const u8 = null,
    hcl: ?[]const u8 = null,
    ecl: ?[]const u8 = null,
    pid: ?[]const u8 = null,
    //    cid: ?[]const u8 = null,

    pub fn check(self: *Passport) bool {
        for (std.meta.fields(Passport)) |field| {
            if (@field(self, field.value) == null) {
                return false;
            }
        }
        return true;
    }
};

const pass_fields = comptime std.meta.fields(Passport);

fn keyis(key: []const u8, word: []const u8) bool {
    return std.mem.startsWith(u8, word, key) and word[4] == ':';
}

pub fn main() !void {
    var passport_it = std.mem.split(input, "\n\n");
    var valids: usize = 0;

    while (passport_it.next()) |text| {
        var pass = Passport{};
        var kv_it = std.mem.tokenize(text, " \n");
        while (kv_it.next()) |kv| {
            for (pass_fields) |field| {
                if (keyis(field.name, kv)) {
                    @field(p, field.name) = kv;
                    break;
                }
            }
        }
        if (pass.check()) valids += 1;
    }
    print("found {} valid passports\n", .{valids});
}
