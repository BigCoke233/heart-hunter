Player = {}
Player.__index = Player

local FrameTimer = require "utils.frameTimer"

function Player.new()
    local player = setmetatable({
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        body = Body:new("circle", config.playerSize, nil, 1/16),
        speed = config.defaultPlayerSpeed,
        shieldedTill = 0,
        hearts = { "redheart", "redheart", "redheart", "shinyheart", "shinyheart" },
        facing = Direction.DOWN,
        moving = false,
        frameTimer = FrameTimer:new(config.frameRate, 2)
    }, Player)

    return player
end

function Player:isShielded()
    return self.shieldedTill >= G.time
end

function Player:isAlive()
    return #self.hearts ~= 0
end
