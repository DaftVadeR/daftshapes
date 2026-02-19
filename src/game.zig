const std = @import("std");
const rl = @import("raylib");
const game = @import("game.zig");

pub const GameState = enum {
    Menu,
    Play,
    Pause,
};

pub const Game = struct {
    state: GameState,
    allocator: std.mem.Allocator,
    // other fields...

    pub fn init(allocator: std.mem.Allocator) !*Game {
        const self = try allocator.create(Game);

        self.* = .{
            .state = .Menu,
            .allocator = allocator,
        };

        // init child resources here, e.g:
        // self.player = try Player.init(allocator);
        return self;
    }

    pub fn deinit(self: *Game) void {
        // deinit children first, then self
        // self.player.deinit();
        self.allocator.destroy(self);
    }

    pub fn draw(self: *Game) void {
        if (self.state == .Menu) {
            rl.drawText("Hello Menu", 50, 50, 8, rl.Color.purple);
        } else if (self.state == .Play) {
            rl.drawText("Hello Game", 50, 50, 8, rl.Color.red);
        }
    }

    pub fn update(self: *Game) void {
        if (self.state == .Menu) {} else if (self.state == .Play) {}
    }
};
