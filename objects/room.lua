Room = {}
Room.__index = Room

local RoomType = {
    INITIAL = 1,
    COMBAT = 2,
    LOOT = 3
}

Direction = {
    LEFT = 1, RIGHT = 2, TOP = 3, BOTTOM = 4
}

function Room:new()
    local obj = {
        width = 0.85, height = 0.8,
        doors = { false, false, false, false },
        borders = {},
        enemies = {},
        isCleared = false,
        type = RoomType.INITIAL
    }

    setmetatable(obj, Room)

    obj.doors[math.random(1, 4)] = true
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

function Room:switch(to)
    if type(to) == "table" then
        G.currentRoom = to
    elseif type(to) == "number" then
        G.currentRoom = G.currentRoom.doors[Direction[to]]
    end
end

return Room
