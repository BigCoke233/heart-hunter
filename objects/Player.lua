local Body = require "objects.Body"
local physics = require "logic.physics"
require "data.directions"

local Player = {}
Player.__index = Player

local FrameTimer = require "utils.frameTimer"

function Player.new()
    local player = setmetatable({
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        body = Body:new("circle", config.playerSize, nil, 1/16),
        speed = config.defaultPlayerSpeed,
        shieldedTill = 0,
        hearts = { "redheart", "redheart", "redheart", "shinyheart", "shinyheart", "stickyheart" },
        facing = Direction.DOWN,
        moving = false,
        frameTimer = FrameTimer:new(config.frameRate, 2)
    }, Player)

    physics.bodifyObject(G.world, player)

    return player
end

function Player:setX(x)
    self.physicsBody:setX(x)
    self.x = x
end

function Player:setY(y)
    self.physicsBody:setY(y)
    self.y = y
end

function Player:isShielded()
    return self.shieldedTill >= G.time
end

function Player:isAlive()
    return #self.hearts ~= 0
end

function Player:speedUp(increment, duration)
    self.speed = self.speed + increment
    self.speedUpTill = G.time + duration
end

return Player
