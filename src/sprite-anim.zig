const rl = @import("raylib");
const std = @import("std");

// pub const AnimGroup = struct {
//     anims: []SpriteAnim,
// };

pub const SpriteAnim = struct {
    texture: rl.Texture2D,
    frameW: f32,
    frameH: f32,
    cols: usize,
    totalFrames: usize,
    startFrame: usize = 0,
    fps: f32 = 2.0,
    currentFrame: usize = 0,
    timer: f32 = 0.0,
    path: [:0]u8,

    pub fn init(
        path: []const u8,
        frameW: f32,
        frameH: f32,
        cols: usize,
        totalFrames: usize,
        fps: f32,
        startFrame: usize,
    ) !SpriteAnim {
        var buf: [256]u8 = undefined;
        const path_z = try std.fmt.bufPrintZ(&buf, "{s}", .{path});

        return SpriteAnim{
            .path = path_z,
            .frameW = frameW,
            .frameH = frameH,
            .cols = cols,
            .totalFrames = totalFrames,
            .fps = fps,
            .startFrame = startFrame,
            .texture = try rl.Texture.init(path_z), // Texture loading
        };
    }

    pub fn denit(self: *SpriteAnim) void {
        rl.unloadTexture(self.texture);
        // allocator.destroy(self)
    }

    pub fn update(self: *SpriteAnim, dt: f32) void {
        self.timer += dt;
        if (self.timer >= 1.0 / self.fps) {
            self.timer = 0; // or -= 1/fps for perfect timing
            self.currentFrame = (self.currentFrame + 1) % self.totalFrames;
        }
    }

    pub fn draw(self: SpriteAnim, pos: rl.Vector2, scale: f32, facingX: f32, tint: rl.Color) void {
        // offset currentFrame by startFrame to index into the correct row/region
        const frame = self.startFrame + self.currentFrame;
        const col = frame % self.cols;
        const row = frame / self.cols;

        // negate src width to flip horizontally when facing left
        const srcWidth = if (facingX < 0) -self.frameW else self.frameW;

        const src = rl.Rectangle{
            .x = @as(f32, @floatFromInt(col)) * self.frameW,
            .y = @as(f32, @floatFromInt(row)) * self.frameH,
            .width = srcWidth,
            .height = self.frameH,
        };

        const scaledW = self.frameW * scale;
        const scaledH = self.frameH * scale;

        const dest = rl.Rectangle{
            .x = pos.x,
            .y = pos.y,
            .width = scaledW,
            .height = scaledH,
        };

        // origin at center of scaled sprite so it draws centered on pos
        const origin = rl.Vector2{ .x = scaledW / 2.0, .y = scaledH / 2.0 };

        rl.drawTexturePro(self.texture, src, dest, origin, 0, tint);
    }
};
