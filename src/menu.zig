const std = @import("std");
const rl = @import("raylib");
const game = @import("game.zig");

// ui_camera :: proc() -> rl.Camera2D {
// return {zoom = f32(rl.GetScreenHeight()) / common.PIXEL_WINDOW_HEIGHT}
//
// }

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
    selected_option: u32,
    startGame: *const fn (g: *game.Game) void,

    pub fn update(self: *Menu, g: *game.Game) void {
        if (rl.isKeyPressed(rl.KeyboardKey.up)) {
            self.selected_option -= 1;
        } else if (rl.isKeyPressed(rl.KeyboardKey.down)) {
            self.selected_option += 1;
        }

        if (self.selected_option < 0) {
            self.selected_option = menu_labels.len - 1;
        } else if (self.selected_option >= menu_labels.len) {
            self.selected_option = 0;
        }

        if (rl.isKeyPressed(rl.KeyboardKey.enter)) {
            const selected_menu_option = menu_labels[self.selected_option].option;

            switch (selected_menu_option) {
                .Start => {
                    self.startGame(g);
                },
                .Quit => {
                    rl.closeWindow();
                },
            }
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
// render_menu :: proc() {
//  rl.BeginMode2D(ui_camera())
//  // NOTE: `fmt.ctprintf` uses the temp allocator. The temp allocator is
//  // cleared at the end of the frame by the main application, meaning inside
//  // `main_hot_reload.odin`, `main_release.odin` or `main_web_entry.odin`.
//  for item, index in menu_labels {
//      rl.DrawText(fmt.ctprintf(item.label), common.PIXEL_WINDOW_WIDTH / 2 - 20, cast(i32)(20 * (index + 1)), 8, rl.WHITE)
//  }
// }
