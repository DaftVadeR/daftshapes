const std = @import("std");
const rl = @import("raylib");
const thing = @import("thing");
const vec2 = thing.vectors.vec2;
const game = @import("game.zig");
const character = @import("character.zig");
const weapon = @import("weapon.zig");
const sprite = @import("sprite.zig");

pub const PlayerKind = enum {
    Karen,
    Knight,
};

pub const PlayerClass = struct {
    attributes: character.CharacterAttributes,
    sprite: sprite.Sprite,
    spritePath: []const u8,

    pub fn init(path: []const u8, attributes: character.CharacterAttributes) !PlayerClass {
        return PlayerClass{
            .spritePath = path,
            .sprite = try sprite.Sprite.init(path), // load texture
            .attributes = attributes,
        };
    }
};

pub fn getKaren() !PlayerClass {
    // DO NOT USE - KNIGHT IS FIRST POC
    return try PlayerClass.init("", character.CharacterAttributes{
        .strength = 5,
        .speed = 80,
        .magic = 5,
        .attack_speed = 70,
        .default_weapons = [1]weapon.Weapon{weapon.energyWeapon},
    });
}

pub fn getKnight() !PlayerClass {
    return try PlayerClass.init(
        "resources/images/player/knight_spritesheet.png",
        character.CharacterAttributes{
            .strength = 10,
            .speed = 50,
            .magic = 10,
            .attack_speed = 50,
            .default_weapons = [1]weapon.Weapon{weapon.energyWeapon},
        },
    );
}

pub const Player = struct {
    last_run: usize,
    run_level: usize,
    experience: f128,
    level: i32,
    player_type: PlayerKind,
    player_detail: PlayerClass,

    pub fn init(
        // playerType: PlayerKind,
    ) !Player {
        return Player{
            .last_run = 0,
            .run_level = 0,
            .experience = 0,
            .level = 1,
            .player_type = .Knight,
            .player_detail = try getKnight(),
        };
    }

    // pub fn getAttributes(self: *Player) character.CharacterAttributes {
    //     return switch (self.player_type) {
    //         .Karen => self.player_detail.karen.attributes,
    //         .Knight => self.player_detail.karen.attributes,
    //     };
    // }

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

        self.player_detail.sprite.position.x += movement[0];
        self.player_detail.sprite.position.y += movement[1];
    }
};
