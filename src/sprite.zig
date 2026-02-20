const std = @import("std");
const rl = @import("raylib");

// deprecated
pub const Sprite = struct {
    texture: rl.Texture2D,
    name: []const u8,

    // size to render each texture rectangle
    // squareSize: usize,
    //
    // // how big rectangles are in the source image
    // sourceSquareSize: usize,
    //
    // // file dimensions so that it calculate the number of squares
    // sourceFileWidth: usize,
    // sourceFileHeight: usize,

    pub fn init(path: []const u8) !Sprite {
        var buf: [256]u8 = undefined;
        const path_z = try std.fmt.bufPrintZ(&buf, "{s}", .{path});

        return Sprite{
            .texture = try rl.Texture.init(path_z), // Texture loading
            .name = path, // maybe not just path later

            .position = rl.Vector2{ .x = 0, .y = 0 },
            .translate = rl.Vector2{ .x = 0, .y = 0 },
        };
    }

    pub fn denit(self: *Sprite) void {
        rl.unloadTexture(self.texture);
    }

    // pub fn init(name: []const u8, texture_path: []const u8) !Sprite {
    //
    // return Sprite{
    //     .texture = knight, // for now its not dynamic
    //     .name = name,
    //     .position = rl.Vector2{ .x = 0, .y = 0 },
    //     .translate = rl.Vector2{ .x = 0, .y = 0 },
    // };
    // }
};
