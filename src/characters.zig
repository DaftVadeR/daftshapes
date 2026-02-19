const std = @import("std");
const rl = @import("raylib");
const game = @import("game.zig");

const PlayerKind = enum {
    Karen,
    Knight,
};

const KarenPlayer = struct {
    // Karen specific data
    attributes: PlayerAttributes,
};

const KnightPlayer = struct {
    // Knight specific data
    attributes: PlayerAttributes,
};

const Player = struct {
    last_run: usize,
    run_level: usize,
    experience: f128,
    level: i32,
    player_type: PlayerKind,
    player_detail: union(PlayerKind) {
        KnightPlayer,
        KarenPlayer,
    },
    sprite: Sprite,
};

const Weapon = struct {
    name: []const u8,
    damage: i32,
    range: f32,
    damage_type: DamageType,
    impact_type: ImpactType,
};

const EnergyWeapon = Weapon{
    .name = "Energy Weapon",
    .damage = 10,
    .range = 100.0,
    .damage_type = .Physical,
    .impact_type = .Direct,
};

const DamageType = enum {
    Physical,
};

const ImpactType = enum {
    AOE,
    Direct,
};

// later

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
    sprite: Sprite,

    position: rl.Vector2(0, 0),
    translate: rl.Vector2(0, 0),
};

// pub const Player = struct {};
//
// pub const PlayerCharacter = struct {};
//
pub const SpriteType = union(enum) {
    Enemy: ?Enemy,
    // Character: ?PlayerCharacter,
};

pub const Sprite = struct {
    texture: rl.Texture2D,
    spriteType: SpriteType,

    name: []const u8,
    position: rl.Vector2(0, 0),
    translate: rl.Vector2(0, 0),
};

pub const PlayerAttributes = struct {
    strength: u32,
    magic: u32,
    speed: u32,
    attack_speed: u32,
    default_weapons: []Weapon,
};
