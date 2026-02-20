const std = @import("std");
const rl = @import("raylib");
const game = @import("game.zig");
const common = @import("common.zig");

// ui_camera :: proc() -> rl.Camera2D {
// return {zoom = f32(rl.GetScreenHeight()) / common.PIXEL_WINDOW_HEIGHT}
//
// }
//

const MenuOption = enum {
    Start,
    // Options,
    Quit,
};

const MenuLabel = struct {
    option: MenuOption,
    label: []const u8,
};

// static menu
const menu_labels = [_]MenuLabel{
    .{ .option = .Start, .label = "Start" },
    .{ .option = .Quit, .label = "Quit" },
};

pub const Menu = struct {
    selected_option: usize,
    startGame: ?*const fn (g: *game.Game) void,

    pub fn draw(self: Menu) !void {
        self.draw_bg();
        try self.draw_menu_items();
    }

    pub fn update(self: *Menu, g: *game.Game) void {
        if (rl.isKeyPressed(rl.KeyboardKey.up)) {
            std.debug.print("up...\n", .{});
            if (self.selected_option > 0) {
                self.selected_option -= 1;
            } else {
                self.selected_option = menu_labels.len - 1;
            }
        } else if (rl.isKeyPressed(rl.KeyboardKey.down)) {
            std.debug.print("doown...\n", .{});
            if (self.selected_option < menu_labels.len - 1) {
                self.selected_option += 1;
            } else {
                self.selected_option = 0;
            }
        } else if (rl.isKeyPressed(rl.KeyboardKey.enter)) {
            std.debug.print("enter...\n", .{});
            const selected_menu_option = menu_labels[self.selected_option].option;

            switch (selected_menu_option) {
                .Start => {
                    std.debug.print("Starting game...\n", .{});
                    if (self.startGame) |startFn| {
                        startFn(g);
                    }
                },
                .Quit => {
                    std.debug.print("Quitting game...\n", .{});
                    rl.closeWindow();
                },
            }
        }
    }

    fn draw_bg(_: Menu) void {
        rl.clearBackground(rl.Color.dark_gray);
    }

    fn draw_menu_items(self: Menu) !void {
        for (menu_labels, 0..) |item, index| {
            var buf: [256]u8 = undefined;
            const menu_name_z = try std.fmt.bufPrintZ(&buf, "{s}", .{item.label});
            const index_int: i32 = @intCast(index);

            var color = rl.Color.ray_white;

            if (self.selected_option == index_int) {
                color = rl.Color.gold;
            }

            const increment: i32 = 50;
            const font_size: i32 = 100;

            const text_dimensions = rl.measureTextEx(
                try rl.getFontDefault(),
                menu_name_z,
                font_size,
                0,
            );

            const text_dimensions_y_i32: i32 = @intFromFloat(text_dimensions.y);

            const half_x: i32 = @intFromFloat(@divTrunc(text_dimensions.x, 2));

            const length: i32 = @intCast(menu_labels.len);
            const height_of_all_text: i32 = @intCast((increment * index_int) + (text_dimensions_y_i32 * length));

            // const line_pos_y: i32 = height_of_all_text;
            const y = common.desiredScreenHeight / 2 - @divTrunc(height_of_all_text, 2) + (increment * index_int) + ((index_int) * text_dimensions_y_i32);

            rl.drawText(
                menu_name_z,
                @intCast(common.desiredScreenWidth / 2 - half_x),
                @intCast(y),
                font_size,
                color,
            );
        }
    }
};

//
// update_menu :: proc(on_play: () -> void, ) {
//  // input: rl.Vector2
//
//  if rl.IsKeyDown(.UP) || rl.IsKeyDown(.W) {
//      menu_state.selected_option -= 1
//  }
//
//  if rl.IsKeyDown(.DOWN) || rl.IsKeyDown(.S) {
//      menu_state.selected_option -= 1
//  }
//
//  if rl.IsKeyDown(.ENTER) {
//     if(menu_state.selected_option == Menu_Option.Start) {
//       on_play()
//     } else if(menu_state.selected_option == Menu_Option.Quit) {
//       os.exit(0)
//     }
//  }

// if rl.IsKeyDown(.LEFT) || rl.IsKeyDown(.A) {
// input.x -= 1
// }
// if rl.IsKeyDown(.RIGHT) || rl.IsKeyDown(.D) {
// input.x += 1
// }

//     if rl.IsKeyPressed(.ESCAPE) {
//         os.exit(0)
//     }
// }
//

//
