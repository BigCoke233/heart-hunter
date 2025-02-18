Room = {}
Room.__index = Room

local RoomType = {
    INITIAL = 1,
    COMBAT = 2,
    LOOT = 3
}

function Room:new(type, w, h)
    local obj = {
        type = type or RoomType.INITIAL,
        width = w or 0.85,
        height = h or 0.8,
        doors = {},
        enemies = {},
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

function Room:addDoor(door)
    table.insert(self.doors, door)
end

function Room.switch(to)
    if type(to) == "table" then
        G.currentRoom = to
    elseif type(to) == "number" then
        G.currentRoom = G.currentRoom.doors[Direction[to]]
    end
end

function Room.generate()
    local room1 = Room:new()
    local room2 = Room:new()
    Door.connect(room1, room2, "lr")

    local room3 = Room:new()
    Door.connect(room3, room2, "tb")

    return room1
end

return Room
