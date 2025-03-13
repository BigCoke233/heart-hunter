require "data.directions"
local Body = require "objects.Body"
local physics = require "logic.physics"
local bullets = require "logic.bullets"
local map = require "logic.map"
local FrameTimer = require "utils.frameTimer"

local Player = {}
Player.__index = Player

function Player.new()
    local player = setmetatable({
        objectType = "player",
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

-- placement and location

function Player:setX(x)
    self.physicsBody:setX(x)
    self.x = x
end

function Player:setY(y)
    self.physicsBody:setY(y)
    self.y = y
end

function Player:move(v)
    self.moving = (v.x ~= 0 or v.y ~= 0)
    self.physicsBody:setLinearVelocity(v.x, v.y)
end

-- status getter

function Player:isShielded()
    return self.shieldedTill >= G.time
end

function Player:isAlive()
    return #self.hearts ~= 0
end

function Player:ammoCooling()
    return G.player.shootCooldown and G.player.shootCooldown > G.time
end

-- control functions

function Player:speedUp(increment, duration)
    self.speed = self.speed + increment
    self.speedUpTill = G.time + duration
end

function Player:shoot(target)
    local hearts = self.hearts
    local currentBullet = hearts[#hearts]

    -- red hearts and the last heart will take some more time to shoot
    if currentBullet == "redheart" or #hearts == 1 then
        -- set a charging time to warn the player that this is a deadly move
        -- if no charging time is set, then set it and shoot no bullet
        if not G.player.chargingStarted then
            G.player.chargingStarted = G.time
            return
        end
        -- if charging time is set, then check if it's over 1 second
        -- if not, shoot no bullet
        if G.time - G.player.chargingStarted <= 1 then return
        -- if time's up, reset timer and continue shooting
        else
            G.player.chargingStarted = nil
        end
    end

    -- shoot the bullet
    bullets.fire(currentBullet, target, self)
    table.remove(self.hearts)

    G.player.shootCooldown = G.time + config.playerShootCooldown
end

function Player:onContact(other, contact)
    -- detect contact with enemies
    -- if collision occurs, take it as an attack
    if other.objectType == "enemy" then
        if not (other.stunned or self:isShielded()) then
            table.remove(self.hearts)
            -- shield this player
            self.shieldedTill = G.time + config.playerShieldTime
        end
    end
end

function Player:update(dt)
    -- temp
    self.x = self.physicsBody:getX()
    self.y = self.physicsBody:getY()

    -- deal with speed up time
    if self.speedUpTill and self.speedUpTill < G.time then
        self.speed = config.defaultPlayerSpeed
        self.speedUpTill = nil
    end

    self.frameTimer:update(dt)
end

return Player
