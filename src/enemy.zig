const std = @import("std");
const rl = @import("raylib");
const zlm = @import("zlm");
const character = @import("character.zig");
const sprite = @import("sprite.zig");

const TriangleEnemy = struct {};
const CircleEnemy = struct {};

// Bosses
const RectangleEnemy = struct {};
const OvalEnemy = struct {};

pub const ShapeEnemy = union(enum) {
    Triangle: TriangleEnemy,
    Circle: CircleEnemy,
    Rectangle: RectangleEnemy,
    Oval: OvalEnemy,
};

pub const Enemy = struct {
    shape: ShapeEnemy,
    attributes: character.CharacterAttributes,
    position: rl.Vector2 = .{ .x = 0, .y = 0 },
    translate: rl.Vector2 = .{ .x = 0, .y = 0 },
};
