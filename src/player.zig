const std = @import("std");
const rl = @import("raylib");
const zlm = @import("zlm");
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
        var newInput: rl.Vector2 = rl.Vector2{
            .x = 0,
            .y = 0,
        };

        const frameTime = rl.GetFrameTime();
        const playerAttributes = self.player_detail.attributes;

        // update translation
        if (rl.IsKeyDown(.UP) || rl.IsKeyDown(.W)) {
            newInput.y -= playerAttributes.speed;
        }

        if (rl.IsKeyDown(.DOWN) || rl.IsKeyDown(.S)) {
            newInput.y += playerAttributes.speed;
        }

        if (rl.IsKeyDown(.LEFT) || rl.IsKeyDown(.A)) {
            newInput.x -= playerAttributes.speed;
        }

        if (rl.IsKeyDown(.RIGHT) || rl.IsKeyDown(.D)) {
            newInput.x += playerAttributes.speed;
        }

        // input = linalg.normalize0(input);
        self.player_pos += newInput * frameTime;
    }
};
