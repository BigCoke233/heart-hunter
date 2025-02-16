Room = {}

local RoomType = {
    INITIAL = 1,
    COMBAT = 3,
    LOOT = 3
}

DoorDirection = {
    LEFT=1, RIGHT=2, TOP=3, BOTTOM=4
}

function Room:new()
    local obj = {
        width = 0.85, height = 0.8,
        doors = { false, false, false, false },
        enemies = {},
        isCleared = false,
        type = RoomType.COMBAT
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Room:getInitial()
    local room = Room:new()
    room.doors[math.random(1,4)] = true
    room.enemies = {}
    room.type = RoomType.INITIAL
    return room
end

function Room:switch(to)
    if type(to) == "table" then
        G.currentRoom = to
    elseif type(to) == "number" then
        G.currentRoom = G.currentRoom.doors[DoorDirection[to]]
    end
end

return Room
