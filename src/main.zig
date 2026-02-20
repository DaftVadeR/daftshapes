// raylib-zig (c) Nikolas Wipper 2023

const rl = @import("raylib");
const std = @import("std");
const game = @import("game.zig");

// fn getRandomTextureSquare(_: usize) TextureSquare {
//     return TextureSquare{
//         .id = 0, //testing
//     };
// }

const desiredScreenWidth: i32 = 1280;
const desiredScreenHeight: i32 = 720;

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------

    rl.initWindow(desiredScreenWidth, desiredScreenHeight, "Fearsome Shapes");

    const monitor: i32 = rl.getCurrentMonitor();

    const monitorWidth: i32 = rl.getMonitorWidth(monitor);
    const monitorHeight: i32 = rl.getMonitorHeight(monitor);

    const posX: i32 = @divTrunc(monitorWidth, 2) - @divTrunc(desiredScreenWidth, 2);
    const posY: i32 = @divTrunc(monitorHeight, 2) - @divTrunc(desiredScreenHeight, 2);

    rl.setWindowPosition(posX, posY);

    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    var g = try game.Game.init(allocator);

    // load assets simply for now

    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        g.update();

        rl.beginDrawing();

        defer rl.endDrawing();

        rl.clearBackground(.black);

        g.draw();

        //----------------------------------------------------------------------------------
    }
}
