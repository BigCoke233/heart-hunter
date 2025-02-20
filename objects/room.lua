require "data.roomData"

Room = {}
Room.__index = Room

function Room:new(name, w, h)
    local obj = {
        name = name or "defaultRoom",
        type = roomData[name].type or roomType.INITIAL,
        width = roomData[name].width or 0.85,
        height = roomData[name].height or 0.8,
        enemies = roomData[name].enemies or {},

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

function Room:getRandomPosition(offset)
    local x = math.random(self:getX() + offset, self:getX() + self:getWidth() - offset)
    local y = math.random(self:getY() + offset, self:getY() + self:getHeight() - offset)
    return x, y
end

function Room:addDoor(door)
    table.insert(self.doors, door)
end
