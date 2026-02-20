// raylib-zig (c) Nikolas Wipper 2023

const rl = @import("raylib");
const std = @import("std");
const game = @import("game.zig");
const common = @import("common.zig");

// fn getRandomTextureSquare(_: usize) TextureSquare {
//     return TextureSquare{
//         .id = 0, //testing
//     };
// }

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    rl.initWindow(common.desiredScreenWidth, common.desiredScreenHeight, "Fearsome Shapes");

    const monitor: i32 = rl.getCurrentMonitor();

    const monitorWidth: i32 = rl.getMonitorWidth(monitor);
    const monitorHeight: i32 = rl.getMonitorHeight(monitor);

    const posX: i32 = @divTrunc(monitorWidth, 2) - @divTrunc(common.desiredScreenWidth, 2);
    const posY: i32 = @divTrunc(monitorHeight, 2) - @divTrunc(common.desiredScreenHeight, 2);

    rl.setWindowPosition(posX, posY);

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second

    var dba: std.heap.DebugAllocator(.{}) = .init;
    const allocatorBase = dba.allocator();

    // use page allocator later as base, with arena on top
    // var arena = std.heap.ArenaAllocator.init(allocatorBase);
    // const allocator = arena.allocator();
    // defer allocator.deinit();

    defer _ = dba.deinit();

    var g = try game.Game.init(allocatorBase);

    defer g.deinit();

    var closed_manually: bool = false;

    // load assets simply for now

    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        g.update();

        if (rl.windowShouldClose()) {
            closed_manually = true;
            break;
        }

        rl.beginDrawing();

        defer rl.endDrawing();

        rl.clearBackground(.black);

        try g.draw();

        //----------------------------------------------------------------------------------
    }

    if (!closed_manually) {
        rl.closeWindow(); // Close window and OpenGL context
    }
}
