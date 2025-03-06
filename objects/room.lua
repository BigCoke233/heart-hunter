require "data.directions"
local roomData = require "data.roomData"
local roomNames = require "data.roomNames"
local roomType = require "data.roomType"

local Enemy = require "objects.enemy"
local Door = require "objects.door"
local Obstacle = require "objects.obstacle"

local Room = {}
Room.__index = Room

function Room:new(name)
    local function readObjectList(data, objectName)
        local list = {}
        for _, object in ipairs(data) do
            local objectType = object[1]
            local objectPosition = object[2]
            local obj = objectName == "enemy" and Enemy:new(objectType, objectPosition) or objectName == "obstacle" and Obstacle:new(objectType, objectPosition) or objectName == "item" and Item:new(objectType, objectPosition)
            table.insert(list, obj)
        end
        return list
    end

    local data = roomData[name or utils.any(roomNames)]
    local obj = {
        name = data.name or "Initial Room",
        type = data.type or roomType.INITIAL,
        width = data.width or 0.85,
        height = data.height or 0.8,
        enemies = data.enemies and readObjectList(data.enemies, "enemy") or {},
        obstacles = data.obstacles and readObjectList(data.obstacles, "obstacle") or {},
        loots = data.loots and readObjectList(data.loots, "loot") or {},

        doors = {},
        isCleared = false,
        -- borders are automatically caculated afterwards
        borders = {},
    }

    setmetatable(obj, Room)

    obj.borders = obj:getBorders()

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

function Room:isDoorFull()
    return #self.doors >= 4
end

function Room:getDoorlessDirections()
    local doorless = { Direction.LEFT, Direction.RIGHT, Direction.TOP, Direction.BOTTOM }
    for _, door in ipairs(self.doors) do
        table.remove(doorless, door.direction)
    end
    return doorless
end

-- initializers

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
            obstacle.x = obstacle.x - obstacle.body.w / 2
            obstacle.y = obstacle.y - obstacle.body.h / 2
        end
    end
end

function Room:init()
    self:initEnemies()
    self:initObstacles()
end

-- control functions

function Room:addDoor(door)
    table.insert(self.doors, door)
end

function Room:connect(anotherRoom, way)
    if self:isDoorFull() or anotherRoom:isDoorFull() then
        return false
    end

    -- determine directions
    -- if not specified, choose randomly
    local directions = Way[way or Ways[way or utils.any(self:getDoorlessDirections())]]
    if not directions then return false end

    -- connect room with determined direction
    local door1 = Door:new(directions[1], self, anotherRoom)
    local door2 = Door:new(directions[2], anotherRoom, self)
    self:addDoor(door1)
    anotherRoom:addDoor(door2)

    return door1, door2
end

return Room
