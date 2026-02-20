const std = @import("std");
const rl = @import("raylib");
const thing = @import("thing");
const vec2 = thing.vectors.vec2;
const game = @import("game.zig");
const character = @import("character.zig");
const weapon = @import("weapon.zig");
const sprite = @import("sprite-anim.zig");

pub const PlayerKind = enum {
    // Karen,
    Knight,
};

pub const PlayerClass = struct {
    attributes: character.CharacterAttributes,

    pub fn init(
        // path: []const u8,
        attributes: character.CharacterAttributes,
    ) !PlayerClass {
        // var attrs = attributes;

        // attrs.spritePath = path;
        // attrs.sprite = try sprite.Sprite.init(path);

        return PlayerClass{
            .attributes = attributes,
        };
    }

    pub fn deinit(self: *PlayerClass) void {
        self.attributes.deinit();
    }
};

// pub fn getKaren() !PlayerClass {
//     // DO NOT USE - KNIGHT IS FIRST POC
//     return try PlayerClass.init("", character.CharacterAttributes.init{
//
//         .strength = 5,
//         .speed = 80,
//         .magic = 5,
//         .attack_speed = 70,
//         .default_weapons = [1]weapon.Weapon{weapon.energyWeapon},
//     });
// }

pub fn getKnight(allocator: std.mem.Allocator) !PlayerClass {
    var anims = try allocator.alloc(sprite.SpriteAnim, 1);

    var weapons = try allocator.alloc(weapon.Weapon, 1);

    anims[0] = try sprite.SpriteAnim.init(
        "resources/images/player/knight_spritesheet.png",
        16,
        16,
        6,
        12,
        1,
    );

    weapons[0] = weapon.energyWeapon;

    return try PlayerClass.init(
        // "resources/images/player/knight_spritesheet.png",
        character.CharacterAttributes.init(
            allocator,
            anims,
            weapons,
        ),
    );

    // {
    //     .strength = 10,
    //     .speed = 50,
    //     .magic = 10,
    //     .attack_speed = 50,
    //     .default_weapons = ,
    //     .sprite = sprite.SpriteAnim.init(
    //
    //     ),
    //     .spritePath = undefined,
    //     .position = rl.Vector2{ .x = 0, .y = 0 },
    //     .translate = rl.Vector2{ .x = 0, .y = 0 },
    // },
}

pub const Player = struct {
    last_run: usize,
    run_level: usize,
    experience: f128,
    level: i32,
    player_type: PlayerKind,
    player_detail: PlayerClass,

    pub fn init(
        allocator: std.mem.Allocator,
        // playerType: PlayerKind,
    ) !Player {
        return Player{
            .last_run = 0,
            .run_level = 0,
            .experience = 0,
            .level = 1,
            .player_type = .Knight,
            .player_detail = try getKnight(allocator),
        };
    }

    pub fn deinit(self: *Player) void {
        self.player_detail.deinit();
    }

    // pub fn getAttributes(self: *Player) character.CharacterAttributes {
    //     return switch (self.player_type) {
    //         .Karen => self.player_detail.karen.attributes,
    //         .Knight => self.player_detail.karen.attributes,
    //     };
    // }

    pub fn draw(self: *Player) void {
        self.player_detail.attributes.anims[self.player_detail.attributes.default_anim].draw(
            self.player_detail.attributes.position,
            5.0,
            rl.Color.white,
        );

        // const spr = self.player_detail.attributes.sprite;
        // // draw first frame (16x16) of the spritesheet at the sprite position
        //
        // const height: f32 = @floatFromInt(spr.texture.height);
        // const width: f32 = @floatFromInt(spr.texture.width);
        //
        // rl.drawTextureRec(
        //     spr.texture,
        //     rl.Rectangle{
        //         .x = 0,
        //         .y = 0,
        //         .width = 16,
        //         .height = 16,
        //     },
        //     // center sprite
        //     rl.Vector2{
        //         .x = spr.position.x - width / 2,
        //         .y = spr.position.y - height / 2,
        //     },
        //     rl.Color.white,
        // );
    }

    pub fn update(self: *Player) void {
        var inputDir: vec2.V = vec2.ZERO;

        const frameTime = rl.getFrameTime();
        const speed = self.player_detail.attributes.speed;

        // collect raw direction input (-1/+1 per axis)
        if (rl.isKeyDown(.up) or rl.isKeyDown(.w)) {
            inputDir[1] -= 1;
        }

        if (rl.isKeyDown(.down) or rl.isKeyDown(.s)) {
            inputDir[1] += 1;
        }

        if (rl.isKeyDown(.left) or rl.isKeyDown(.a)) {
            inputDir[0] -= 1;
        }

        if (rl.isKeyDown(.right) or rl.isKeyDown(.d)) {
            inputDir[0] += 1;
        }

        // normalize so diagonal movement isnt faster than cardinal
        const normalized = vec2.normalize(inputDir);
        const movement = vec2.mulN(normalized, speed * frameTime);

        self.player_detail.attributes.position.x += movement[0];
        self.player_detail.attributes.position.y += movement[1];
    }
};
