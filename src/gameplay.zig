const std = @import("std");
const rl = @import("raylib");
const zlm = @import("zlm");
const player = @import("player.zig");
const character = @import("character.zig");
const sprite = @import("sprite.zig");
const weapon = @import("weapon.zig");
const game = @import("game.zig");
const common = @import("common.zig");
const enemy = @import("enemy.zig");

pub const GamePlay = struct {
    player: player.Player,
    enemies: []enemy.Enemy,
    camera: rl.Camera2D,
    allocator: std.mem.Allocator,
    exitToMenu: *const fn (g: *game.Game) void,

    pub fn init(
        allocator: std.mem.Allocator,
        g: *game.Game,
        exitToMenu: *const fn (g: *game.Game) void,
    ) !GamePlay {
        const p = try player.Player.init(g.allocator);

        const enemies = try allocator.alloc(enemy.Enemy, 1);
        enemies[0] = try enemy.Shape.init(allocator, .Triangle, p);

        return GamePlay{
            .enemies = enemies,
            .allocator = allocator,
            .player = p,
            .exitToMenu = exitToMenu,
            .camera = rl.Camera2D{
                // offset is the screen point the camera target maps to (center of screen)
                .offset = rl.Vector2{
                    .x = @as(f32, @floatFromInt(common.desiredScreenWidth)) / 2.0,
                    .y = @as(f32, @floatFromInt(common.desiredScreenHeight)) / 2.0,
                },
                // target is the world position the camera looks at (player position)
                .target = p.player_detail.attributes.position,
                .rotation = 0,
                .zoom = 1,
            },
        };
    }

    pub fn deinit(self: *GamePlay) void {
        self.player.deinit();
    }

    pub fn draw(self: *GamePlay) void {
        self.camera.begin();

        defer self.camera.end();

        // draw a ground grid as a visual reference for movement
        const gridSize: i32 = 128;
        const gridCount: i32 = 24;

        const halfGrid: i32 = gridCount * gridSize / 2;

        var i: i32 = 0;
        while (i <= gridCount) : (i += 1) {
            const pos = -halfGrid + i * gridSize;
            // vertical lines
            rl.drawLine(pos, -halfGrid, pos, halfGrid, rl.Color.dark_gray);
            // horizontal lines
            rl.drawLine(-halfGrid, pos, halfGrid, pos, rl.Color.dark_gray);
        }

        self.player.draw();

        for (self.enemies) |enem| {
            enem.draw();
        }
    }

    pub fn update(self: *GamePlay, _: *game.Game) void {
        // if (rl.isKeyPressed(rl.KeyboardKey.escape)) {
        //     std.debug.print("back to menu...\n", .{});
        //     self.exitToMenu(g);
        //     return;
        // }

        self.player.update();

        for (self.enemies) |*enem| {
            enem.update();
        }

        // keep camera following the player
        self.camera.target = self.player.player_detail.attributes.position;
    }
};
