require "data.directions"
local roomData = require "data.roomData"
local roomNames = require "data.roomNames"
local roomType = require "data.roomType"
local Door = require "objects.door"
local audio = require "utils.audio"
local mapHelper = require "utils.mapHelper"

local Room = {}
Room.__index = Room

function Room:new(name)
    local dataName = name or utils.any(roomNames)
    local data = roomData[dataName]
    local obj = {
        dataName = dataName,
        name = data.name or "Initial Room",
        type = data.type or roomType.INITIAL,
        width = data.width or 0.85,
        height = data.height or 0.8,

        objects = {
            enemies = data.enemies and utils.readObjectList(data.enemies, "enemy") or {},
            obstacles = data.obstacles and utils.readObjectList(data.obstacles, "obstacle") or {},
            loots = data.loots and utils.readObjectList(data.loots, "loot") or {},
            shots = {}
        },

        doors = {},
        isCleared = false,

        music = data.music or nil,
    }

    setmetatable(obj, Room)

    return obj
end

-- getters

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

    local doorLocations = {}
    for _, door in pairs(self.doors) do
        local doorX, doorY = door.x, door.y
        local doorW, doorH = door.w, door.h

        local lookupTable = {
            [Direction.LEFT] = {
                x = doorX + doorW, y = doorY
            },
            [Direction.RIGHT] = {
                x = doorX - doorW, y = doorY
            },
            [Direction.TOP] = {
                x = doorX, y = doorY + doorH
            },
            [Direction.BOTTOM] = {
                x = doorX, y = doorY - doorH
            },
        }

        local pos = lookupTable[door.location]
        table.insert(doorLocations, { x=pos.x, y=pos.y })
    end
    preset.anyDoor = utils.any(doorLocations)

    return preset[location].x, preset[location].y
end

function Room:isDoorFull()
    return #self.doors >= 4
end

function Room:hasDoor(location)
    return self.doors[location] ~= nil
end

function Room:getDooredDirections()
    local doored = {}
    for _, door in pairs(self.doors) do
        table.insert(doored, door.location)
    end
    return doored
end

function Room:getDoorlessDirections()
    local doored = self:getDooredDirections()
    local doorless = {}
    for direction = 1, 4 do
        if not utils.contains(doored, direction) then
            table.insert(doorless, direction)
        end
    end
    return doorless
end

-- control functions

function Room:addDoor(location, to)
    if self:hasDoor(location) then
        print("door location unavailable")
        return false
    end

    local door = Door:new(location, self, to)
    self.doors[location] = door

    return door
end

function Room:removeDoor(location)
    self.doors[location] = nil
end

function Room:connect(anotherRoom, way)
    if self:isDoorFull() or anotherRoom:isDoorFull() then
        return false
    end

    -- determine directions
    local directions = {}
    if type(way) == "string" then
        directions = Way[way]
    elseif type(way) == "number" then
        directions = Way[Ways[way]]
    else
        -- if not specified, choose randomly
        local pairedDirections = mapHelper.getAvailablePairedDirections(self, anotherRoom)
        directions = utils.any(pairedDirections)
    end
    if not directions then return false end

    -- connect room with determined direction
    return self:addDoor(directions[1], anotherRoom),
        anotherRoom:addDoor(directions[2], self)
end

-- initializers

function Room:addWalls()
    local x, y, w, h = self:getX(), self:getY(), self:getWidth(), self:getHeight()
    local thickness = 2
    local walls = {}

    local borders = {
        { x = x, y = y + h / 2, w = thickness, h = h },
        { x = x + w, y = y + h / 2, w = thickness, h = h },
        { x = x + w / 2, y = y, w = w, h = thickness },
        { x = x + w / 2, y = y + h, w = w, h = thickness }
    }

    for _, b in ipairs(borders) do
        local wall = {
            objectType = "wall",
            x = b.x, y = b.y
        }
        G.BodyLifeCycleManager:create(wall, { b.w, b.h }, "static")
        table.insert(walls, wall)
    end

    return walls
end


function Room:init()
    -- handle objects that need to be placed
    for _, group in pairs(self.objects) do
        for _, object in ipairs(group) do
            if object.placeInRoom then
                object:placeInRoom(self)
            end
        end
    end

    for _, door in pairs(self.doors) do
        G.BodyLifeCycleManager:create(door, { door.w, door.h }, "static")
    end

    self.walls = self:addWalls()

    -- play music
    if not self.isCleared then
        if self.music then
            audio.music(self.music)
        elseif self.music == "no" then
            audio.stopMusic()
        else
            audio.music(config.defaultMusic)
        end
    end
end

function Room:unload()
    for _, group in pairs(self.objects) do
        for _, obj in ipairs(group) do
            G.BodyLifeCycleManager:destroy(obj.physicsBody)
        end
        group = {}
    end

    for _, wall in ipairs(self.walls) do
        G.BodyLifeCycleManager:destroy(wall.physicsBody)
    end
    self.walls = {}

    for _, door in pairs(self.doors) do
        G.BodyLifeCycleManager:destroy(door.physicsBody)
    end

    self.objects.shots = {}
end

function Room:update(dt)
    for _, group in pairs(self.objects) do
        for _, obj in ipairs(group) do
            obj:update(dt)
        end
    end
end

return Room
