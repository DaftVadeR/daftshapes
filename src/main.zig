// raylib-zig (c) Nikolas Wipper 2023

const rl = @import("raylib");
const std = @import("std");
const game = @import("game.zig");
const common = @import("common.zig");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    rl.initWindow(common.desiredScreenWidth, common.desiredScreenHeight, "Fearsome Shapes");

    const monitor: i32 = rl.getCurrentMonitor();

    const monitorWidth: i32 = rl.getMonitorWidth(monitor);
    const monitorHeight: i32 = rl.getMonitorHeight(monitor);

    const posX: i32 = @divTrunc(monitorWidth, 2) - @divTrunc(common.desiredScreenWidth, 2);
    const posY: i32 = @divTrunc(monitorHeight, 2) - @divTrunc(common.desiredScreenHeight, 2);

    rl.setExitKey(rl.KeyboardKey.slash);

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

    var closed_ingame: bool = false;

    while (!rl.windowShouldClose()) { // detect external close requests
        g.update();

        if (rl.windowShouldClose()) { // detect in-game close requests
            closed_ingame = true;
            break;
        }

        rl.beginDrawing();

        defer rl.endDrawing();

        rl.clearBackground(.black);

        try g.draw();
    }

    if (!closed_ingame) { // if closed externally (window closed, raylib escape key, alt F4 etc.)
        rl.closeWindow();
    }
}
