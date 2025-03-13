require "data.directions"
local Loot = require "objects.Loot"
local physics = require "logic.physics"
local enemyData = require "data.enemyData"
local FrameTimer = require "utils.frameTimer"
local audio = require "utils.audio"

local Enemy = {}
Enemy.__index = Enemy

function Enemy:new(name, location)
    local data = enemyData[name]
    local obj = {
        objectType = "enemy",
        type = name,
        presetLocation = (type(location) == "string" and location) or nil,
        x = (type(location) == "table" and location.x) or nil,
        y = (type(location) == "table" and location.y) or nil,
        r = data.size or nil,
        zoom = data.zoom or 1,
        speed = data.speed or nil,
        health = data.health or nil,
        stunned = false,
        frameTimer = FrameTimer:new(config.frameRate,
            (data.sprite and data.sprite.totalFrames) or 1),
        movePattern = data.movePattern or nil,
    }

    setmetatable(obj, Enemy)

    return obj
end

function Enemy:move(dt)
    -- deal with stunned status
    if self.stunned and self.stunned > 0 then
        self.stunned = self.stunned - dt
        self.physicsBody:setLinearVelocity(0, 0)
        return false
    elseif self.stunned and self.stunned <= 0 then
        self.stunned = nil
    end

    -- deal with sticky status
    if self.sticky and self.sticky > 0 then
        self.sticky = self.sticky - dt
        if not self.originalSpeed then
            self.originalSpeed = self.speed
        end
        self.speed = self.originalSpeed / (self.sticky + 1)
    elseif self.sticky and self.sticky <= 0 then
        self.sticky = nil
        self.speed = self.originalSpeed
    end

    if self.movePattern == "vertical" then
        self:moveVertical(G.player.x, dt)
    else self:moveTo(G.player.x, G.player.y, dt)
    end
end

function Enemy:moveTo(x, y, dt)
    local dv = self.speed

    local dx, dy = x - self.physicsBody:getX(), y - self.physicsBody:getY()
    local dist = math.sqrt(dx * dx + dy * dy)

    if dist > 0 then
        dx, dy = dx / dist, dy / dist
    end

    local vx, vy = dx * dv, dy * dv
    self.physicsBody:setLinearVelocity(vx, vy)
end

function Enemy:moveVertical(toX, dt)
    self:moveTo(toX, self.y, dt)
end

function Enemy:facing()
    local dx = self.x - G.player.x
    local dy = self.y - G.player.y
    local angle = math.atan2(dy, dx)

    local dir
    if angle >= -math.pi / 4 and angle < math.pi / 4 then
        dir = Direction.LEFT
    elseif angle >= math.pi / 4 and angle < 3 * math.pi / 4 then
        dir = Direction.UP
    elseif angle >= -3 * math.pi / 4 and angle < -math.pi / 4 then
        dir = Direction.DOWN
    else
        dir = Direction.RIGHT
    end

    return dir
end

function Enemy:takeDamage(damage)
    self.health = self.health - damage
    if self:isDead() then
        self:die()
    end
end

function Enemy:isDead()
    return self.health <= 0
end

function Enemy:die()
    audio.play("hit")

    -- drop loots
    for i, item in ipairs(enemyData[self.type].drops) do
        local temp = math.random(10) / 10
        if temp <= item.chances then
            local offset = (i - 1) * 5
            local lootItem = Loot:new(item.type, self.x + offset, self.y + offset)
            table.insert(G.currentRoom.objects.loots, lootItem)
        end
    end

    local enemies = G.currentRoom.objects.enemies
    G.BodyLifeCycleManager:destroy(self.physicsBody)
    table.remove(enemies, utils.indexof(enemies, self))
end

function Enemy:stun(duration)
    self.stunned = duration
end

function Enemy:getSticky(duration)
    self.sticky = duration
end

function Enemy:onHit(shot)
    if enemyData[self.type] and enemyData[self.type].onHit then
        enemyData[self.type].onHit(shot)
    end
end

function Enemy:update(dt)
    self:move(dt)
    self.frameTimer:update(dt)

    local data = physics.getObjectPosition(self)
    self.x, self.y = data.x, data.y
end

return Enemy
