const std = @import("std");
const rl = @import("raylib");
const game = @import("game.zig");
const menu = @import("menu.zig");
const gameplay = @import("gameplay.zig");

pub const GameState = enum {
    Menu,
    Play,
    Pause,
};

pub const Game = struct {
    state: GameState,
    allocator: std.mem.Allocator,
    menu: menu.Menu,
    gameplay: ?gameplay.GamePlay,

    // other fields...

    pub fn init(allocator: std.mem.Allocator) !*Game {
        const self = try allocator.create(Game);

        // this assumes the menu is always first to show - this isnt ideal for flexibility.
        self.* = .{
            .gameplay = null,
            .state = .Menu,
            .allocator = allocator,
            .menu = menu.Menu{
                .selected_option = 0,
                .startGame = null,
            },
        };

        self.menu.startGame = &Game.start;

        // init child resources here, e.g:
        // self.player = try Player.init(allocator);
        return self;
    }

    pub fn start(self: *Game) void {
        self.gameplay = gameplay.GamePlay.init(self.allocator, self, &Game.exitToMenu) catch unreachable;
        self.state = .Play;
    }

    pub fn exitToMenu(self: *Game) void {
        self.state = .Menu;
    }

    pub fn deinit(self: *Game) void {
        // deinit children first, then self
        if (self.gameplay) |*gp| {
            gp.deinit();
        }
        self.allocator.destroy(self);
    }

    pub fn draw(self: *Game) !void {
        if (self.state == .Menu) {
            try self.menu.draw();
        } else if (self.state == .Play) {
            if (self.gameplay) |*gp| {
                gp.draw();
            }
        }
    }

    pub fn update(self: *Game) void {
        if (self.state == .Menu) {
            self.menu.update(self);
        } else if (self.state == .Play) {
            if (self.gameplay) |*gp| {
                gp.update(self);
            }
        }
    }
};
