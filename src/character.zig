const std = @import("std");
const rl = @import("raylib");
const zlm = @import("zlm");
const weapon = @import("weapon.zig");

// pub const Player = struct {};
//
// pub const PlayerCharacter = struct {};
//

// applies to player and enemy characters for simplicity sake
pub const CharacterAttributes = struct {
    strength: u32,
    magic: u32,
    speed: u32,
    attack_speed: u32,
    default_weapons: [1]weapon.Weapon,
};
