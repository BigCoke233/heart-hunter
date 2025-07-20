require "data.directions"
local physics = require "logic.physics"

local Door = {}
Door.__index = Door

local function calculateDoorLocation(obj)
    local roomX, roomY = obj.within:getX(), obj.within:getY()
    local roomW, roomH = obj.within:getWidth(), obj.within:getHeight()
    local loc, size, thickness = obj.location, obj.size, obj.thickness

    local positions = {
        [Direction.LEFT]   = { x = roomX, y = (love.graphics.getHeight() - size) / 2, w = thickness, h = size },
        [Direction.RIGHT]  = { x = roomX + roomW, y = (love.graphics.getHeight() - size) / 2, w = thickness, h = size },
        [Direction.TOP]    = { x = (love.graphics.getWidth() - thickness) / 2, y = roomY, w = size, h = thickness },
        [Direction.BOTTOM] = { x = (love.graphics.getWidth() - thickness) / 2, y = roomY + roomH, w = size, h = thickness }
    }

    local pos = positions[loc]
    obj.x, obj.y, obj.w, obj.h = pos.x, pos.y, pos.w, pos.h
end

function Door:new(location, within, to)
    local obj = {
        location = location,
        size = config.graphics.doorSize,
        thickness = config.graphics.doorThickness,

        within = within,
        to = to,
    }

    setmetatable(obj, Door)

    calculateDoorLocation(obj)
    G.BodyLifeCycleManager:create(obj, { obj.w, obj.h }, "static")

    return obj
end

function Door:setTo(room)
    self.to = room
end

function Door:onContact(other)
    local map = require "logic.map"
    if other.objectType == "player" then
        print "player in contact with door"
        if not G.currentRoom.isCleared then return end

        map.switchRoom(self.to)

        -- update player position after entering a new room
        local doorH, doorW, playerR = self.h, self.w, G.player.physicsShape:getRadius()
        local roomX, roomY, roomW, roomH = G.currentRoom:getX(), G.currentRoom:getY(), G.currentRoom:getWidth(), G.currentRoom:getHeight()

        local positions = {
            [Direction.LEFT]   = { "x", roomX + roomW - playerR - doorW },
            [Direction.RIGHT]  = { "x", roomX + playerR + doorW },
            [Direction.TOP]    = { "y", roomY + roomH - playerR - doorH },
            [Direction.BOTTOM] = { "y", roomY + playerR + doorH }
        }

        local axis, pos = positions[self.location][1], positions[self.location][2]
        G.BodyLifeCycleManager:setPosition(G.player, axis, pos)
    end
end

return Door
