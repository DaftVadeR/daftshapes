const std = @import("std");
const rl = @import("raylib");
const zlm = @import("zlm");
const weapon = @import("weapon.zig");
const sprite = @import("sprite-anim.zig");

const STILL: usize = 0;
const MOVING = 1;

// applies to player and enemy characters for simplicity sake
pub const CharacterAttributes = struct {
    strength: f32,
    magic: f32,
    speed: f32,
    attack_speed: f32,
    default_anim: usize,
    position: rl.Vector2,
    allocator: std.mem.Allocator,

    default_weapons: []weapon.Weapon,
    transform: rl.Vector2,
    anims: []sprite.SpriteAnim,

    pub fn init(
        allocator: std.mem.Allocator,
        anims: []sprite.SpriteAnim,
        weapons: []weapon.Weapon,
    ) CharacterAttributes {
        return CharacterAttributes{
            // override these explicitly
            // dont want a giant init function
            .strength = 0,
            .magic = 0,
            .speed = 0,
            .attack_speed = 0,
            .default_anim = 0,
            .position = rl.Vector2{ .x = 0, .y = 0 },
            .allocator = allocator,

            // set via init
            .default_weapons = weapons,
            .transform = rl.Vector2{ .x = 0, .y = 0 },
            .anims = anims,
        };
    }

    pub fn deinit(self: CharacterAttributes) void {
        std.debug.print("Deinitializing CharacterAttributes...\n", .{});

        for (self.anims) |*anim| {
            anim.denit();
        }

        self.allocator.free(self.anims);
        self.allocator.free(self.default_weapons);

        // for (self.default_weapons) |*weapon| {
        //     weapon.denit();
        // }
    }

    pub fn switchAnim(self: CharacterAttributes, animIndex: usize) void {
        if (animIndex < self.anims.len) {
            self.default_anim = animIndex;
        }
    }
};
