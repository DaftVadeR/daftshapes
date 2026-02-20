const std = @import("std");
const rl = @import("raylib");
const zlm = @import("zlm");
const weapon = @import("weapon.zig");

// pub const Player = struct {};
//
// pub const PlayerCharacter = struct {};
//

// applies to player and enemy characters for simplicity sake
pub const CharacterAttributes = struct { // u31 to match up with i32
    strength: f32,
    magic: f32,
    speed: f32,
    attack_speed: f32,
    default_weapons: [1]weapon.Weapon,
};
