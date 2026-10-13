const std = @import("std");
const mem = std.mem;
const testing = std.testing;

fn Equals(comptime T: type) type {
    return fn (a: T, b: T) bool;
}

// TODO: Implemnent the `node_hash_map` from abseil Swiss Tables
pub fn HashMap(comptime K: type, comptime V: type, _: Equals(K)) type {
    _ = V;

    return struct {
        const Self = @This();

        size: usize,
        allocator: mem.Allocator,

        const Errors = error{
            NotImplemented,
        };

        pub fn init(allocator: mem.Allocator) Self {
            return .{ .allocator = allocator, .size = 0 };
        }

        pub fn deinit(self: Self) void {
            _ = self;
        }

        pub fn count(self: Self) usize {
            return self.size;
        }
    };
}

const Context = struct {
    const Self = @This();

    const K = []const u8;
    const V = i32;
    const M = HashMap(K, V, equals);
    const E = M.Errors;

    const Errors = error{
        AllocationFailed,
    };

    fn equals(a: []const u8, b: []const u8) bool {
        return mem.eql(u8, a, b);
    }

    fn nodesInvariantsHold(_: *M) Errors!void {}
};

fn testHashMap(_: Context, smith: *std.testing.Smith) !void {
    const allocator = testing.allocator;

    var oracle: std.AutoHashMap(Context.K, Context.V) = .init(allocator);
    defer oracle.deinit();

    var map: Context.M = .init(allocator);
    defer map.deinit();

    // const Operations = enum {};
    while (!smith.eos()) {
        // const op = smith.value(Operations);

        //         const value = smith.value(Context.T);
        //         const direction = smith.value(Context.D);
        //         const index = smith.valueRangeAtMost(u8, 0, 0x20);

        //switch (op) {}

        //         const expected = oracle.items;
        //         const actual = try list.items(allocator);
        //         defer allocator.free(actual);
        //
        //         try testing.expectEqual(expected.len, actual.len);
        //         try testing.expectEqualSlices(Context.T, expected, actual);

        const expected = oracle.count();
        const actual = map.count();
        try testing.expectEqual(expected, actual);

        // Validate Invariants Integrity
        try Context.nodesInvariantsHold(&map);
    }
}

test "HashMap: Fuzz" {
    try testing.fuzz(Context{}, testHashMap, .{});
}
