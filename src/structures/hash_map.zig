const std = @import("std");
const mem = std.mem;
const testing = std.testing;

fn Equals(comptime T: type) type {
    return fn (a: T, b: T) bool;
}

fn Hash(comptime T: type) type {
    return fn (key: T) []const u8;
}

/// An HashMap Implementation based off of Abseil Swiss Tables
///
/// `K` & `V` are the key and value types, `N` is the group width.
/// `hash` & `equals` is the hashing and comparison functions used for keys.
///
/// This map does not handle memory cleanup for keys or values but only nodes.
pub fn HashMap(comptime K: type, comptime V: type, comptime N: u8, hash: Hash(K), equals: Equals(K)) type {
    _ = hash;
    _ = equals;

    return struct {
        const Self = @This();
        const Metadata = [N]u8;
        const KV = struct { key: K, value: V };

        size: usize,
        groups: [N]KV,
        control: []Metadata,
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

        pub fn add(self: *Self, allocator: mem.Allocator, key: K, value: V) !void {
            _ = self;
            _ = allocator;
            _ = key;
            _ = value;

            return Errors.NotImplemented;
        }

        pub fn rid(self: *Self, allocator: mem.Allocator, key: K) !V {
            _ = self;
            _ = allocator;
            _ = key;

            return Errors.NotImplemented;
        }

        pub fn get(self: *Self, allocator: mem.Allocator, key: K) ?V {
            _ = self;
            _ = allocator;
            _ = key;

            return null;
        }

        pub fn set(self: *Self, allocator: mem.Allocator, key: K) !V {
            _ = self;
            _ = allocator;
            _ = key;

            return null;
        }

        pub fn has(self: *Self, allocator: mem.Allocator, key: K) bool {
            _ = self;
            _ = allocator;
            _ = key;

            return false;
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
    const N = 16;
    const M = HashMap(K, V, N, hash, equals);
    const E = M.Errors;

    const Errors = error{
        AllocationFailed,
    };

    fn equals(a: K, b: K) bool {
        return mem.eql(u8, a, b);
    }

    fn hash(a: K) []const u8 {
        return a;
    }

    fn nodesInvariantsHold(_: *M) Errors!void {}
};

fn testHashMap(_: Context, smith: *std.testing.Smith) !void {
    const allocator = testing.allocator;

    var oracle: std.AutoHashMap(Context.K, Context.V) = .init(allocator);
    defer oracle.deinit();

    // var map: Context.M = .init(allocator);
    // defer map.deinit();

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

        // const expected = oracle.count();
        // const actual = map.count();
        // try testing.expectEqual(expected, actual);

        // Validate Invariants Integrity
        // try Context.nodesInvariantsHold(&map);
    }
}

test "HashMap: Fuzz" {
    try testing.fuzz(Context{}, testHashMap, .{});
}
