local Body = require "objects.Body"
require "data.directions"

local Door = {}
Door.__index = Door

local function calculateDoorLocation(obj)
    local roomX, roomY = obj.within:getX(), obj.within:getY()
    local roomW, roomH = obj.within:getWidth(), obj.within:getHeight()
    local loc, size, thickness = obj.location, obj.size, obj.thickness

    if loc == Direction.LEFT or loc == Direction.RIGHT then
        obj.x = (loc == Direction.LEFT) and (roomX - thickness / 2) or (roomX + roomW - thickness / 2)
        obj.y = (love.graphics.getHeight() - size) / 2
        obj.body = Body:new("rectangle", thickness, size)
    elseif loc == Direction.TOP or loc == Direction.BOTTOM then
        obj.x = (love.graphics.getWidth() - size) / 2
        obj.y = (loc == Direction.TOP) and (roomY - thickness / 2) or (roomY + roomH - thickness / 2)
        obj.body = Body:new("rectangle", size, thickness)
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
        body = nil,
    }

    setmetatable(obj, Door)

    calculateDoorLocation(obj)

    return obj
end

function Door:setTo(room)
    self.to = room
end

return Door
