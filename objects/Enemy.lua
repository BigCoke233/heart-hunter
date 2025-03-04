local enemyData = require "data.enemyData"

Enemy = {}
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
    end
    if self.movePattern == "vertical" then
        self:moveVertical(G.player.x, dt)
    else self:moveTo(G.player.x, G.player.y, dt)
    end
end

function Enemy:moveTo(x, y, dt)
    local dv = self.speed * dt
    local dx, dy = 0, 0

    local function getDirection(axis, playerPos, direction, blockAxis)
        if self[axis] < playerPos then
            if not utils.isBlocked(self.body, self.x, self.y, direction, blockAxis, dv) then
                return 1
            end
        elseif self[axis] > playerPos then
            if not utils.isBlocked(self.body, self.x, self.y, direction, blockAxis, dv) then
                return -1
            end
        end
        return 0
    end

    dx = getDirection("x", x, Direction.RIGHT, "x")
    dy = getDirection("y", y, Direction.DOWN, "y")

    self.x = self.x + dx * dv
    self.y = self.y + dy * dv
end

function Enemy:moveVertical(toX, dt)
    self:moveTo(toX, self.y, dt)
end

function Enemy:facing()
    local dx = self.x - G.player.x
    local dy = self.y - G.player.y
    local angle = math.atan2(dy, dx)  -- 计算角度，弧度制

    -- 判断方向
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
end

function Enemy:stun(duration)
    self.stunned = duration
end
