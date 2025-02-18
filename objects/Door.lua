Door = {}
Door.__index = Door

local function calculateDoorLocation(obj)
    local roomX, roomY = obj.within:getX(), obj.within:getY()
    local roomW, roomH = obj.within:getWidth(), obj.within:getHeight()
    local loc, size, thickness = obj.location, obj.size, obj.thickness

    if loc == Direction.LEFT or loc == Direction.RIGHT then
        obj.x = (loc == Direction.LEFT) and (roomX - thickness / 2) or (roomX + roomW - thickness / 2)
        obj.y = (love.graphics.getHeight() - size) / 2
        obj.width = thickness
        obj.height = size
    elseif loc == Direction.TOP or loc == Direction.BOTTOM then
        obj.x = (love.graphics.getWidth() - size) / 2
        obj.y = (loc == Direction.TOP) and (roomY - thickness / 2) or (roomY + roomH - thickness / 2)
        obj.width = size
        obj.height = thickness
    end
end

function Door:new(location, within, to)
    local obj = {
        location = location,
        size = config.graphics.doorSize,
        thickness = config.graphics.doorThickness,

        within = within,
        to = to,

        x = nil, -- location and size is calculated afterwards
        y = nil,
        width = nil, -- width and height are for graphics, calculated based on size and thickness
        height = nil,
    }

    setmetatable(obj, Door)

    calculateDoorLocation(obj)

    return obj
end

function Door:setTo(room)
    self.to = room
end

function Door.connect(room1, room2, way)
    local door1, door2
    if way == "lr" then
        door1 = Door:new(Direction.LEFT, room1, room2)
        door2 = Door:new(Direction.RIGHT, room2, room1)
        room1:addDoor(door1)
        room2:addDoor(door2)
    elseif way == "tb" then
        door1 = Door:new(Direction.TOP, room1, room2)
        door2 = Door:new(Direction.BOTTOM, room2, room1)
        room1:addDoor(door1)
        room2:addDoor(door2)
    end
    return door1, door2
end

return Door
