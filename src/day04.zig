const std = @import("std");
const Allocator = std.mem.Allocator;
const assert = std.debug.assert;
const print = std.debug.print;

const input = @embedFile("../in04.txt");

const valid_ecls = .{
    "amb", "blu", "brn", "gry", "grn", "hzl", "oth",
};

fn in_range(comptime T: type, num: ?[]const u8, min: T, max: T) bool {
    var n = std.fmt.parseInt(T, num orelse "", 10) catch |e| return false;
    return (n >= min and n <= max);
}

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
        print("CHECKING: ", .{});
        if (!in_range(i16, self.byr, 1920, 2002)) return false;
        print("valid byr 1920<={}<=2002 - ", .{self.byr});
        if (!in_range(i16, self.iyr, 2010, 2020)) return false;
        print("valid iyr 2010<={}<=2020 - ", .{self.iyr});
        if (!in_range(i16, self.eyr, 2020, 2030)) return false;
        print("valid eyr 2020<={}<=2030 - ", .{self.eyr});

        if (self.hgt) |hgt| {
            var hgtnum = hgt[0 .. hgt.len - 2];
            if (std.mem.endsWith(u8, hgt, "in")) {
                if (!in_range(u16, hgtnum, 59, 76)) return false;
                print("valid hgt 59in <= {} <= 76 - ", .{hgtnum});
            } else if (std.mem.endsWith(u8, hgt, "cm")) {
                if (!in_range(u8, hgtnum, 150, 193)) return false;
                print("valid hgt 150cm <= {} <= 193 - ", .{hgtnum});
            } else {
                return false;
            }
        } else {
            print("missing hgt", .{});
            return false;
        }

        if (self.hcl) |hcl| {
            if (hcl[0] != '#' or hcl.len != 7) return false;
            for (hcl[1..]) |c| {
                if (std.mem.indexOfScalar(u8, "0123456789abcdef", c) == null) return false;
            }
            print("valid hcl {} is 6 hex - ", .{hcl});
        } else {
            print("missing hcl", .{});
            return false;
        }

        if (self.ecl) |ecl| {
            inline for (valid_ecls) |c| {
                if (std.mem.eql(u8, ecl, c)) break;
            } else {
                print("unknown ecl", .{});
                return false;
            }
        } else {
            print("missing ecl", .{});
            return false;
        }
        print("valid ecl - ", .{});

        if (self.pid) |pid| {
            if (pid.len != 9) return false;
            for (pid) |c| if (c < '0' or c > '9') return false;
        } else {
            print("missing pid", .{});
            return false;
        }
        print("valid pid - Valid!", .{});

        return true;
    }
};

fn keyis(key: []const u8, word: []const u8) bool {
    var result = std.mem.startsWith(u8, word, key) and word[3] == ':';
    print("keyis({}, {}) -> {}\n", .{ key, word, result });
    return result;
}

pub fn main() !void {
    var passport_it = std.mem.split(input, "\n\n");
    var valids: usize = 0;

    while (passport_it.next()) |text| {
        print("---\ngot Passport text:\n{}\n", .{text});
        var pass = Passport{};
        var kv_it = std.mem.tokenize(text, " \n");
        while (kv_it.next()) |kv| {
            var part_it = std.mem.tokenize(kv, ":");
            var key = part_it.next() orelse "";
            inline for (std.meta.fields(Passport)) |field| {
                if (std.mem.eql(u8, key, field.name)) {
                    @field(pass, field.name) = part_it.next();
                    break;
                }
            }
        }
        if (pass.check()) valids += 1;
        print("\n", .{});
    }
    print("found {} valid passports\n", .{valids});
}
