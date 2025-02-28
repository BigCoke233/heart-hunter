Room = {}
Room.__index = Room

function Room:new(name, w, h)
    local data = roomData[name]
    local obj = {
        name = name or "defaultRoom",
        type = data.type or roomType.INITIAL,
        width = data.width or 0.85,
        height = data.height or 0.8,
        enemies = utils.copy(data.enemies or {}),
        obstacles = utils.copy(data.obstacles or {}),

        doors = {},
        isCleared = false,
        -- borders are automatically caculated afterwards
        borders = {},
    }

    setmetatable(obj, Room)

    obj.borders = obj:getBorders()

    return obj
end

function Room:getWidth()
    return self.width * love.graphics.getWidth()
end

function Room:getHeight()
    return self.height * love.graphics.getHeight()
end

function Room:getX()
    return (love.graphics.getWidth() - self:getWidth()) / 2
end

function Room:getY()
    return (love.graphics.getHeight() - self:getHeight()) / 2
end

function Room:getBorders()
    local top = self:getY()
    local bottom = self:getY() + self:getHeight()
    local left = self:getX()
    local right = self:getX() + self:getWidth()
    return { left, right, top, bottom }
end

function Room:getLocation(location, offset)
    if type(location) ~= "string" then
        error("Invalid location type: " .. type(location))
    end

    local preset = {
        topLeft = {
            x = self:getX() + offset,
            y = self:getY() + offset
        },
        topRight = {
            x = self:getX() + self:getWidth() - offset,
            y = self:getY() + offset
        },
        bottomLeft = {
            x = self:getX() + offset,
            y = self:getY() + self:getHeight() - offset
        },
        bottomRight = {
            x = self:getX() + self:getWidth() - offset,
            y = self:getY() + self:getHeight() - offset
        },
        center = {
            x = self:getX() + self:getWidth() / 2,
            y = self:getY() + self:getHeight() / 2
        },
        topCenter = {
            x = self:getX() + self:getWidth() / 2,
            y = self:getY() + offset
        },
        bottomCenter = {
            x = self:getX() + self:getWidth() / 2,
            y = self:getY() + self:getHeight() - offset
        },
        leftCenter = {
            x = self:getX() + offset,
            y = self:getY() + self:getHeight() / 2
        },
        rightCenter = {
            x = self:getX() + self:getWidth() - offset,
            y = self:getY() + self:getHeight() / 2
        },
        random = {
            x = math.random(self:getX() + offset, self:getX() + self:getWidth() - offset),
            y = math.random(self:getY() + offset, self:getY() + self:getHeight() - offset),
        }
    }

    return preset[location].x, preset[location].y
end

function Room:addDoor(door)
    table.insert(self.doors, door)
end

function Room:initEnemies()
    for _, enemy in ipairs(self.enemies) do
        local offset = enemy.body.r*2 + G.player.body.r*2 + config.summonMargin
        if not enemy.x or not enemy.y then
            enemy.x, enemy.y = self:getLocation(enemy.presetLocation or "random", offset)
        end
    end
end

function Room:initObstacles()
    for _, obstacle in ipairs(self.obstacles) do
        local offset = obstacle.body.w + G.player.body.r*2 + config.summonMargin
        if not obstacle.x or not obstacle.y then
            obstacle.x, obstacle.y = self:getLocation(obstacle.presetLocation or "random", offset)
        end
    end
end

function Room:init()
    self:initEnemies()
    self:initObstacles()
end
