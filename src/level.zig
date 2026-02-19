const rl = @import("raylib");
const std = @import("std");

fn drawLevel(level: Level) !void {
    var x: usize = 0;
    var y: usize = 0;

    const result: *[100]u8 = undefined;

    try std.fmt.bufPrint(result, "./resources/images/level/{s}", level.tilemapFile);

    const levelHandle = try rl.loadTexture(result);

    level.levelHandle = levelHandle;

    var rowCount = 0;

    while (rowCount < level.levelLayout.len) {
        var letterCount = 0;

        const row = level.levelLayout[rowCount];

        while (letterCount < row.len) {
            rl.drawTextureRec(
                level.levelHandle.?,
                rl.Rectangle{
                    .x = 0,
                    .y = 0,
                    .width = level.sourceSquareSize,
                    .height = level.sourceSquareSize,
                },
                rl.Vector2{
                    .x = x * level.squareSize,
                    .y = y * level.squareSize,
                },
                .white,
            );

            x = x + 1;

            if (x >= level.width) {
                x = 0;
                y = y + 1;
            }
            letterCount += 1;
        }
        rowCount += 1;
    }
}
// pub const SquareState = enum {
//     Empty,
//     Filled,
// };
//
// pub const TextureSquare = struct {
//     blockId: usize,
//     // state:
// };

pub const Level = struct {
    // level dimensions
    width: usize,
    height: usize,

    // sequential list of texture squares to render, in left-to-right order
    // randomised initially
    layout: []const u8,

    // square width and height
    allocator: std.mem.Allocator,
};

const ImageMap = struct {
    filename: []const u8,
};

const images = [_]ImageMap{
    .{ .filename = "tx_tileset_grass_w_transparency.png" },
};

const TileMap = struct {
    // file path
    filePath: []u8,

    // size to render each texture rectangle
    squareSize: usize,

    // how big rectangles are in the source image
    sourceSquareSize: usize,

    // file dimensions so that it calculate the number of squares
    sourceFileWidth: usize,
    sourceFileHeight: usize,

    // if the tilemap file isnt entirely valid for sourcing grouond textures,
    // pass the cell identifiers manually here.
    validSquaresOverride: ?[]u8,

    levelHandle: ?rl.Texture2D,
};

// means that all squares are going to use the first square in the source image
const levelLayout: [10][]const u8 = [10][]const u8{
    "00000000000000000000",
    "00000000000000000000",
    "00000000000000000000",
    "00000000000000000000",
    "00000000000000000000",
    "00000000000000000000",
    "00000000000000000000",
    "00000000000000000000",
    "00000000000000000000",
    "00000000000000000000",
};
