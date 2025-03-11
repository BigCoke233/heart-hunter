require "data.directions"

local Body = require "objects.Body"
local enemyData = require "data.enemyData"
local physics = require "logic.physics"

require "logic.bullets"

local Enemy = {}
Enemy.__index = Enemy

local FrameTimer = require "utils.frameTimer"

function Enemy:new(name, location)
    local data = enemyData[name]
    local obj = {
        type = name,
        presetLocation = (type(location) == "string" and location) or nil,
        x = (type(location) == "table" and location.x) or nil,
        y = (type(location) == "table" and location.y) or nil,
        body = Body:new("circle",
            data.size or nil, nil,
            data.zoom or 1
        ),
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

function Enemy:isBlocked()

end

function Enemy:move(dt)
    if self.stunned and self.stunned > 0 then
        self.stunned = self.stunned - dt
        return false
    elseif self.stunned and self.stunned <= 0 then
        self.stunned = nil
    end

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

function Enemy:getsAttacked(damage)
    self.health = self.health - damage
    if self:isDead() then
        self:die()
    end
end

function Enemy:isDead()
    return self.health <= 0
end

function Enemy:die()
    -- drop loots
    for i, item in ipairs(enemyData[self.type].drops) do
        local temp = math.random(10) / 10
        if temp <= item.chances then
            local offset = (i - 1) * 5
            loot.drop(self.x + offset, self.y + offset, item.type)
        end
    end

    self.physicsBody:destroy()
end

function Enemy:stun(duration)
    self.stunned = duration
end

function Enemy:getSticky(duration)
    self.sticky = duration
end

function Enemy:getShot()
    local shots = G.currentRoom.objects.shots
    for j, shot in pairs(shots) do
        if self.body:collide(
            shot.body,
            self.x, self.y,
            shot.x, shot.y, shot.size
        ) then
            -- kill entities
            self:getsAttacked(shot.damage)
            local enemies = G.currentRoom.objects.enemies
            if (self:isDead()) then
                table.remove(enemies, utils.indexof(enemies, self))
            end
            -- kill shot
            table.remove(shots, j)
            -- bullet effect
            bullets.hit(shot.type, self.x, self.y, self.type)
        end
    end
end

function Enemy:update(dt)
    self:move(dt)
    self:getShot()
    self.frameTimer:update(dt)

    if not self.physicsBody:isDestroyed() then
        self.x = self.physicsBody:getX()
        self.y = self.physicsBody:getY()
    end
end

return Enemy
