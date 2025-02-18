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

function Room.generate(roomCount)
    -- 创建第一个房间并初始化
    local rooms = {}
    local room1 = Room:new()
    table.insert(rooms, room1)

    -- 按照一定的规则生成房间并连接它们
    for i = 2, roomCount do
        local newRoom = Room:new()
        -- 随机决定连接的方向
        local previousRoom = rooms[math.random(#rooms)]  -- 随机选择一个之前创建的房间

        -- 根据生成的方向连接房间
        Door.connect(previousRoom, newRoom, math.random(4))

        -- 将新房间添加到房间列表
        table.insert(rooms, newRoom)
    end

    -- 返回第一个房间（起点房间）
    return rooms[1]
end

return Room
