Enemy = {}
Enemy.__index = Enemy

function Enemy:new(name, location)
    local obj = {
        type = name,
        presetLocation = (type(location) == "string" and location) or nil,
        x = (type(location) == "table" and location.x) or nil,
        y = (type(location) == "table" and location.y) or nil,
        body = Body:new("circle", enemyData[name] and enemyData[name].size or nil),
        speed = enemyData[name] and enemyData[name].speed or nil,
        health = enemyData[name] and enemyData[name].health or nil,
        stunned = false,
    }

    setmetatable(obj, Enemy)

    return obj
end

function Enemy:isBlocked()

end

function Enemy:moveTowardPlayer(dt)
    if self.stunned and self.stunned > 0 then
        self.stunned = self.stunned - dt
        return false
    end

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

    dx = getDirection("x", G.player.x, Direction.RIGHT, "x")
    dy = getDirection("y", G.player.y, Direction.DOWN, "y")

    self.x = self.x + dx * dv
    self.y = self.y + dy * dv
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
