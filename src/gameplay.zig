const std = @import("std");
const rl = @import("raylib");
const zlm = @import("zlm");
const player = @import("player.zig");
const character = @import("character.zig");
const sprite = @import("sprite.zig");
const weapon = @import("weapon.zig");
const game = @import("game.zig");

pub const GamePlay = struct {
    player: player.Player,
    exitToMenu: *const fn (g: *game.Game) void,

    pub fn init(exitToMenu: *const fn (g: *game.Game) void) !GamePlay {
        return GamePlay{
            .player = try player.Player.init(),
            .exitToMenu = exitToMenu,
        };
    }

    pub fn draw(_: GamePlay) !void {
        // self.player.draw();
    }

    pub fn update(self: *GamePlay, g: *game.Game) void {
        if (rl.isKeyPressed(rl.KeyboardKey.escape)) {
            std.debug.print("back to menu...\n", .{});
            self.exitToMenu(g);
        }

        self.player.update();

        // } else if (rl.isKeyPressed(rl.KeyboardKey.down)) {
        //     std.debug.print("doown...\n", .{});
        //     if (self.selected_option < menu_labels.len - 1) {
        //         self.selected_option += 1;
        //     } else {
        //         self.selected_option = 0;
        //     }
        // } else if (rl.isKeyPressed(rl.KeyboardKey.enter)) {
        //     std.debug.print("enter...\n", .{});
        //     const selected_menu_option = menu_labels[self.selected_option].option;
        //
        //     switch (selected_menu_option) {
        //         .Start => {
        //             std.debug.print("Starting game...\n", .{});
        //             self.startGame(g);
        //         },
        //         .Quit => {
        //             std.debug.print("Quitting game...\n", .{});
        //             rl.closeWindow();
        //         },
        //     }
        // }
    }
};
