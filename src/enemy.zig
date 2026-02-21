const std = @import("std");
const rl = @import("raylib");
const zlm = @import("zlm");
const character = @import("character.zig");
const player = @import("player.zig");
const sprite = @import("sprite.zig");
const weapon = @import("weapon.zig");

const TriangleEnemy = struct {};
const CircleEnemy = struct {};

// Bosses
const RectangleEnemy = struct {};
const OvalEnemy = struct {};

// shape enemies are simple due to using raylib shape draw calls
pub const Shape = struct {
    pub fn init(allocator: std.mem.Allocator, shape_type: ShapeType, target: player.Player) !Enemy {
        const weapons = try allocator.alloc(weapon.Weapon, 0);

        // weapons[0] = weapon.energyWeapon;

        //
        const attribs = character.CharacterAttributes.init(
            allocator,
            null,
            weapons,
        );

        // add shape specific stuff
        switch (shape_type) {
            .Triangle => {},
            .Circle => {},

            .Rectangle => {},
            .Oval => {},
        }

        const shape = Shape{};

        return Enemy{
            .allocator = allocator,
            .shape_type = shape_type,
            .shape = shape,
            .actualEnemy = null,
            .attributes = attribs,
            .target = target,
        };
    }

    pub fn update(_: Shape, attribs: *character.CharacterAttributes, target: player.Player) void {
        std.debug.print("Updating shape enemy...\n", .{});
        // var inputDir: rl.Vector2 = rl.Vector2.zero();

        const frameTime = rl.getFrameTime();
        // const speed = attribs.speed;

        const newVec = rl.Vector2{
            .x = target.player_detail.attributes.position.x - attribs.position.x,
            .y = target.player_detail.attributes.position.y - attribs.position.y,
        };

        const norm = newVec.normalize();

        const diff = rl.Vector2{
            .x = norm.x * attribs.speed * frameTime,
            .y = norm.y * attribs.speed * frameTime,
        };

        attribs.position.x += diff.x;
        attribs.position.x += diff.y;
    }

    pub fn draw(_: Shape, attributes: character.CharacterAttributes, shape_type: ShapeType) void {
        // add shape specific stuff
        switch (shape_type) {
            .Triangle => {
                rl.drawTriangle(
                    rl.Vector2{ .x = attributes.position.x, .y = attributes.position.y - 10 },
                    rl.Vector2{ .x = attributes.position.x - 10, .y = attributes.position.y + 10 },
                    rl.Vector2{ .x = attributes.position.x + 10, .y = attributes.position.y + 10 },
                    rl.Color.red,
                );
            },
            .Circle => {
                rl.drawCircle(
                    @intFromFloat(attributes.position.x),
                    @intFromFloat(attributes.position.y),
                    10.0,
                    rl.Color.red,
                );
            },

            .Rectangle => {
                rl.drawRectangle(
                    @intFromFloat(attributes.position.x - 10),
                    @intFromFloat(attributes.position.y - 10),
                    20.0,
                    20.0,
                    rl.Color.red,
                );
            },
            .Oval => {
                rl.drawEllipse(
                    @intFromFloat(attributes.position.x),
                    @intFromFloat(attributes.position.y),
                    10.0,
                    5.0,
                    rl.Color.red,
                );
            },
        }
    }
};

// once shape enemies are done, we can make animated sprite enemies
pub const ActualEnemy = struct {};

pub const ShapeType = enum {
    Triangle,
    Circle,

    Rectangle,
    Oval,
};

pub const Enemy = struct {
    shape_type: ?ShapeType,
    shape: ?Shape,
    actualEnemy: ?ActualEnemy, // later
    attributes: character.CharacterAttributes,
    target: player.Player,
    allocator: std.mem.Allocator,

    pub fn init(
        allocator: std.mem.Allocator,
        // attributes: character.CharacterAttributes,
        shape_type: ShapeType,
        target: player.Player,
    ) Enemy {
        const enemy = try Shape.init(allocator, shape_type, target);

        return enemy;
    }

    pub fn deinit(self: Enemy) void {
        self.attributes.deinit();
    }

    pub fn draw(self: Enemy) void {
        // only move shapes for now, as its different for sprites
        if (self.shape) |shape| {
            if (self.shape_type) |shape_type| {
                std.debug.print("Drawing enemy...\n", .{});
                shape.draw(self.attributes, shape_type);
            }
        }
    }

    pub fn update(self: *Enemy) void {

        // only move shapes for now, as its different for sprites
        if (self.shape) |shape| {
            std.debug.print("Updating enemy...\n", .{});
            shape.update(&self.attributes, self.target);
        }

        // inputDir =

        // let moving = Vec3::normalize(player_transform.translation - transform.translation)
        //         * enemy.speed
        //         * time.delta_seconds();
        // if enemy.health <= 0. {
        //                 commands.entity(entity).despawn();
        //             }

        // 2. Normalise so diagonal isn't faster
        // const length = std.math.sqrt(dx * dx + dy * dy);
        // if (length > 0) {
        //     dx /= length;   // now length is exactly 1
        //     dy /= length;
        // }
        //
        // update facing direction based on horizontal input
        // if (inputDir[0] < 0) {
        //     self.player_detail.attributes.transform.x = -1;
        // } else if (inputDir[0] > 0) {
        //     self.player_detail.attributes.transform.x = 1;
        // }
        // if no horizontal input, keep the last facing direction

        // if (inputDir[0] == 0 and inputDir[1] == 0) {
        //     self.player_detail.attributes.default_anim = 0; // idle
        // } else {
        //     self.player_detail.attributes.default_anim = 1; // run
        // }

        // normalize so diagonal movement isnt faster than cardinal
        // const normalized = vec2.normalize(inputDir);
        // const movement = vec2.mulN(normalized, speed * frameTime);
        //
        // self.player_detail.attributes.position.x += movement[0];
        // self.player_detail.attributes.position.y += movement[1];
        //
        // if (self.player_detail.attributes.anims) |anims| {
        //     anims[self.player_detail.attributes.default_anim].update(frameTime);
        // }
    }
};
