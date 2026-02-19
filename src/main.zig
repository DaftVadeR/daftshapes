// raylib-zig (c) Nikolas Wipper 2023

const rl = @import("raylib");

const desiredScreenWidth: i32 = 1280;
const desiredScreenHeight: i32 = 720;

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------

    rl.initWindow(desiredScreenWidth, desiredScreenHeight, "raylib-zig [core] example - basic window");

    const monitor: i32 = rl.getCurrentMonitor();

    const monitorWidth: i32 = rl.getMonitorWidth(monitor);
    const monitorHeight: i32 = rl.getMonitorHeight(monitor);

    const posX: i32 = @divTrunc(monitorWidth, 2) - @divTrunc(desiredScreenWidth, 2);
    const posY: i32 = @divTrunc(monitorHeight, 2) - @divTrunc(desiredScreenHeight, 2);

    rl.setWindowPosition(posX, posY);

    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.white);

        rl.drawText("Congrats! You created your first window!", 190, 200, 20, .light_gray);
        //----------------------------------------------------------------------------------
    }
}
