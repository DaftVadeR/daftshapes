const std = @import("std");
const rl = @import("raylib");
const zlm = @import("zlm");
const player = @import("player.zig");
const character = @import("character.zig");
const sprite = @import("sprite.zig");
const weapon = @import("weapon.zig");

pub const GamePlay = struct {
    player: player.Player,

    pub fn init() !GamePlay {
        return GamePlay{
            .player = try player.Player.init(),
        };
    }
};
