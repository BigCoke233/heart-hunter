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
    }

    setmetatable(obj, Enemy)

    return obj
end

function Enemy:isBlocked()

end

function Enemy:moveTowardPlayer(dt)
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
